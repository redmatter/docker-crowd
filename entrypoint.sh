#!/bin/bash

: ${CATALINA_CONNECTOR_PROXYNAME:=crowd}
: ${CATALINA_CONNECTOR_PROXYPORT:=443}
: ${CATALINA_CONNECTOR_SCHEME:=https}

: ${CATALINA_OPTS:=}
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyName=${CATALINA_CONNECTOR_PROXYNAME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyPort=${CATALINA_CONNECTOR_PROXYPORT}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorScheme=${CATALINA_CONNECTOR_SCHEME}"

catalina_sh="${CROWD_INSTALL_DIR}/apache-tomcat/bin/catalina.sh"

stop_catalina() {
	echo stop_catalina: SIGTERM received;
	${catalina_sh} stop;
}

trap 'stop_catalina' SIGTERM

export CATALINA_OPTS
exec ${catalina_sh} run
