function echoAndRun {
    echo "$@"
    "$@"
}

function atom {
    echoAndRun /cygdrive/c/Users/cdrolet/AppData/Local/atom/bin/atom.cmd "$@"
}

function pushToZRepo {
  gitc new zconfig $(date)
  gitph
}

function changeToZDir {
  previousDir="$PWD"
  cd ~/zshcustom/
}

function goBackAndReload {
  cd ${previousDir}
  zreload
}

# Very verbose command to bypass a bug in cygwin

function openZConfig {
  targetdir=~/zshcustom/
  echoAndRun atom C:/dev/app/.babun/cygwin/${targetDir}
}

function saveZConfig {
  changeToZDir
  pushToZRepo
  goBackAndReload
}


alias lll="ls -qaltr"

alias zreload="echoAndRun source ~/.zshrc"

alias zconfig="openZConfig"

alias zsave="saveZConfig"

alias tmux="tmux -f ~/.tmux/.tmux.conf -2"


