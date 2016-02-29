FROM java:7

MAINTAINER Dino.Korah@redmatter.com

ENV TZ="Europe/London" \
    CROWD_VERSION="2.8.4" \
    CROWD_HOME="/var/atlassian/application-data/crowd" \
    CROWD_INSTALL_DIR="/opt/atlassian/crowd" \
    # unprivileged users used to run the app
    RUN_USER=daemon \
    RUN_GROUP=daemon

ADD https://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-${CROWD_VERSION}.tar.gz /tmp/files.tar.gz
#COPY atlassian-crowd-${CROWD_VERSION}.tar.gz /tmp/files.tar.gz
COPY entrypoint.sh setenv.sh https_proxy_server_xml.patch /

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \
    export BUILD_DEPS="patch"; \
    export APP_DEPS="libtcnative-1"; \

    set -e -u -x; \

    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ${APP_DEPS} ${BUILD_DEPS}; \

    mkdir -p ${CROWD_INSTALL_DIR}; \
    tar -C ${CROWD_INSTALL_DIR} --strip-components=1 -xzf /tmp/files.tar.gz; \
    echo "crowd.home=${CROWD_HOME}" >> ${CROWD_INSTALL_DIR}/crowd-webapp/WEB-INF/classes/crowd-init.properties; \

    mkdir ${CROWD_INSTALL_DIR}/apache-tomcat/lib/native; \
    ln --symbolic "/usr/lib/x86_64-linux-gnu/libtcnative-1.so" "${CROWD_INSTALL_DIR}/apache-tomcat/lib/native/libtcnative-1.so"; \
    mv setenv.sh ${CROWD_INSTALL_DIR}/apache-tomcat/bin/setenv.sh; \
	patch -p1 -d ${CROWD_INSTALL_DIR} < /https_proxy_server_xml.patch; \
	rm /https_proxy_server_xml.patch; \

    wget -qO- https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz | \
        tar -xz -O mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar >"${CROWD_INSTALL_DIR}/apache-tomcat/lib/mysql-connector-java-5.1.38-bin.jar"; \

    mkdir -p ${CROWD_HOME}; \

    chown -R ${RUN_USER}:${RUN_GROUP} ${CROWD_INSTALL_DIR} ${CROWD_HOME}; \
    chmod -R go-rwx ${CROWD_INSTALL_DIR}/apache-tomcat/logs ${CROWD_INSTALL_DIR}/apache-tomcat/temp ${CROWD_INSTALL_DIR}/apache-tomcat/work; \

    apt-get remove -y $BUILD_DEPS; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/{apt,dpkg,cache,log}/; \
)

USER ${RUN_USER}:${RUN_GROUP}

VOLUME ["${CROWD_HOME}"]

# HTTP port
EXPOSE 8095

WORKDIR ${CROWD_INSTALL_DIR}

# STOPSIGNAL SIGTERM

CMD ["/entrypoint.sh"]

