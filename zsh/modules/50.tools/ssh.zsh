checkcert() {
  echoAndRun openssl s_client -debug -connect "${1}"
}