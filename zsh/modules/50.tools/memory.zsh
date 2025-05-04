##############################################################
# FUNCTION
##############################################################

# Top ten memory hogs
# http://www.commandlinefu.com/commands/view/7139/top-ten-memory-hogs
memtop() {
    ps -eorss,args | sort -nr | pr -TW$COLUMNS | head
}
zle -N memtop

