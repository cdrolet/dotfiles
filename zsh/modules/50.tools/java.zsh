##############################################################
# JAVA
##############################################################

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_13_HOME=$(/usr/libexec/java_home -v13)
export JAVA_15_HOME=$(/usr/libexec/java_home -v15)
export JAVA_16_HOME=$(/usr/libexec/java_home -v16)

export JAVA_HOME=$JAVA_11_HOME

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java13='export JAVA_HOME=$JAVA_13_HOME'
alias java15='export JAVA_HOME=$JAVA_15_HOME'
alias java16='export JAVA_HOME=$JAVA_16_HOME'