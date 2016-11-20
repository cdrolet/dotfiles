## curlheader will return the header value specified for a given URL
## usage: curlheader ${header} ${url}
## or get all headers
## curlheader ${url}
curlheader() {
  if [[ -z "$2" ]]; then
    echoAndRun curl -k -s -D - $1 -o /dev/null:
  else
    echoAndRun curl -k -s -D - $2 -o /dev/null | grep $1:
  fi
}

## hammer a service with curl for a given number of times
curlhammer () {
  echo "about to hammer $1 with $2 curls ⇒";
  echo "curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'"
  for i in {1..$2}
  do
    curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'
  done
  echo "done"
}
