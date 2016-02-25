JVM_MINIMUM_MEMORY="128m"
JVM_MAXIMUM_MEMORY="512m"

JAVA_OPTS="-Xms${JVM_MINIMUM_MEMORY} -Xmx${JVM_MAXIMUM_MEMORY} -XX:MaxPermSize=256m -Dfile.encoding=UTF-8 $JAVA_OPTS"
JAVA_OPTS="-Djava.library.path=$CATALINA_HOME/lib/native $JAVA_OPTS"
JAVA_OPTS="-Djava.awt.headless=true $JAVA_OPTS"

export JAVA_OPTS

# set the location of the pid file
if [ -z "$CATALINA_PID" ] ; then
    if [ -n "$CATALINA_BASE" ] ; then
        CATALINA_PID="$CATALINA_BASE"/work/catalina.pid
    elif [ -n "$CATALINA_HOME" ] ; then
        CATALINA_PID="$CATALINA_HOME"/work/catalina.pid
    fi
fi
export CATALINA_PID
