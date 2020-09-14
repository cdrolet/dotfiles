##############################################################
# JAVA
##############################################################

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_13_HOME=$(/usr/libexec/java_home -v13)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java13='export JAVA_HOME=$JAVA_13_HOME'