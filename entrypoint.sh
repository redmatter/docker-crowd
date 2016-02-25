#!/bin/bash

catalina_sh="${CROWD_INSTALL_DIR}/apache-tomcat/bin/catalina.sh"

stop_catalina() {
	echo stop_catalina: SIGTERM received;
	${catalina_sh} stop;
}

trap 'stop_catalina' SIGTERM

exec ${catalina.sh} run
