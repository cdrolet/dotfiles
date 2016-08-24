readonly MAVEN_PROFILE='-P DEV,under-integration-test'
readonly MAVEN_THREADS='-T 1C'
readonly MAVEN_OPTIONS='$MAVEN_PROFILE $MAVEN_THREADS'

function mavenTree {
	echoAndRun mvn dependency:tree -Dverbose -Dincludes="$*"
}

#function gitflowrelease {
	#git reset --hard HEAD &&
	#git clean -f -d &&
	#git checkout master &&
	#git pull &&
	#git checkout develop &&
	#git pull &&
	#mvn jgitflow:release-start &&
	#mvn jgitflow:release-start
#}

alias mvni="echoAndRun mvn install $MAVEN_OPTIONS"

alias mvnc="echoAndRun mvn clean $MAVEN_OPTIONS"

alias mvnci="echoAndRun mvn clean install $MAVEN_OPTIONS"

alias mvns="echoAndRun mvn install -DskipTests $MAVEN_OPTIONS"

alias mvnt="mavenTree"

#alias mvnrelease="gitflowrelease"
