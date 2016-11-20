
function vimHelp {
  echo
  echo ".MODE"
  echo "ESC: normal mode" 
  echo "i: insert mode"
  echo "R: replace mode"
  echo ": exec command or go to line"
  echo
  echo ".COMMAND"
  echo ":w: save file"
  echo ":wq: save and quit"
  echo ":q!: quit without saving"
  echo ".: repeat command"
  echo
  echo ".NAVIGATION"
  echo "A: append at eol"
  echo "0: jump begin of line"
  echo "$: jump eol"
  echo "w/W: next word (include or not non blank char)"
  echo "b/B: previous word (include or not non blank char)"
  echo "e/E: end word (include or not non blank char)"
  echo "G: end of document"	
  echo
  echo ".UNDO/REDO"
  echo "u: undo"
  echo "ctrl-R: redo"
  echo 
  echo ".SELECTION"
  echo "v: select characters"
  echo "V: select whole line"
  echo "Ctrl-v select block"
  echo
  echo ".CUTTING/PASTING"
  echo "d: cut selected"
  echo "dd: cut whole line"
  echo "y: copy selected"
  echo "yy: copy whole line"
  echo "p: paste before cursor"
  echo "P: paste after"
  echo "X: backspace"
  echo "x: delete"
  echo
  echo ".SEARCH"
  echo "/: search forward"
  echo "?: search backward"
  echo "n: next"
  echo "N: previous"
  echo "*: forward of the exact current word"
  echo "#: backward of the exact current word"
  echo "g* | g#: not exact word"
  echo	
			 
}

alias vimh="echoAndRun vimHelp"


