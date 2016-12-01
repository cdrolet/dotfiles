##############################################################
# FUNCTIONS
##############################################################

# mvn-color based on https://gist.github.com/1027800
BOLD=`tput bold`
UNDERLINE_ON=`tput smul`
UNDERLINE_OFF=`tput rmul`
TEXT_BLACK=`tput setaf 0`
TEXT_RED=`tput setaf 1`
TEXT_GREEN=`tput setaf 2`
TEXT_YELLOW=`tput setaf 3`
TEXT_BLUE=`tput setaf 4`
TEXT_MAGENTA=`tput setaf 5`
TEXT_CYAN=`tput setaf 6`
TEXT_WHITE=`tput setaf 7`
BACKGROUND_BLACK=`tput setab 0`
BACKGROUND_RED=`tput setab 1`
BACKGROUND_GREEN=`tput setab 2`
BACKGROUND_YELLOW=`tput setab 3`
BACKGROUND_BLUE=`tput setab 4`
BACKGROUND_MAGENTA=`tput setab 5`
BACKGROUND_CYAN=`tput setab 6`
BACKGROUND_WHITE=`tput setab 7`
RESET_FORMATTING=`tput sgr0`

readonly MAVEN_THREADS='-T 1C'

# Wrapper function for Maven's mvn command.
mvn-color()
{
  (
  # Filter mvn output using sed. Before filtering set the locale to C, so invalid characters won't break some sed implementations
  unset LANG
  LC_CTYPE=C mvn $@ | sed -e "s/\(BUILD SUCCESS\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
                -e "s/\(SUCCESS\)/${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
                -e "s/\(BUILD FAILURE\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\]\)\(.*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[FAILURE\]\)\(.*\)/${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[ERROR\]\)\(.*\)/${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${TEXT_YELLOW}\4${RESET_FORMATTING}/g"

  # Make sure formatting is reset
  echo -ne ${RESET_FORMATTING}
  )
}

##############################################################
# ALIAS
##############################################################

# Override the mvn command with the colorized one.
alias mvn="echoAndRun mvn-color ${MAVEN_THREADS}"

alias mvnc='mvn clean'
alias mvni='mvn install'
alias mvnci='mvn clean install'
alias mvns='mvn clean install -DskipTests'

alias mvnso='mvn clean install -DskipTests --offline'

alias mvnd='mvn deploy'
alias mvnp='mvn package'
alias mvncom='mvn compile'
alias mvnt='mvn test'

alias mvntree='mvn dependency:tree -Dverbose -Dincludes=$1'
alias mvnag='mvn archetype:generate'
alias mvn-updates='mvn versions:display-dependency-updates'
alias mvns='mvn site'
alias mvnsrc='mvn dependency:sources'
alias mvndocs='mvn dependency:resolve -Dclassifier=javadoc'

