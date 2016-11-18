if [[ "$OSTYPE" != darwin* ]]; then
  return 1
fi


export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"