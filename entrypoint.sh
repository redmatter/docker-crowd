#!/bin/bash

catalina_sh="${CROWD_INSTALL_DIR}/apache-tomcat/bin/catalina.sh"

trap '${catalina_sh} stop' SIGTERM

exec ${catalina.sh} run
