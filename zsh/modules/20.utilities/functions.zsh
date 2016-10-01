
# Top ten memory hogs
# http://www.commandlinefu.com/commands/view/7139/top-ten-memory-hogs
memtop() {
    ps -eorss,args | sort -nr | pr -TW$COLUMNS | head
}
zle -N memtop

# show newest files
# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
newest () {
    find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".hg" | grep -v ".git" | sort -r | less
}

# create a new script, automatically populating the shebang line, editing the
# script, and making it executable.
# http://www.commandlinefu.com/commands/view/8050/
shebang() {
    name=${1:?filename required}
    shell=${2:-bash}

    if i=$(which $shell); then
        printf '#!/usr/bin/env %s\n\n' $shell > $name && chmod 755 $name && vim + $name && chmod 755 $name;
    else
        echo "'which' could not find $shell, is it in your \$PATH?";
    fi;
    # in case the new script is in path, this throw out the command hash table and
    # start over  (man zshbuiltins)
    rehash
}

# compress to bz2
2bz () {
    name=$1;
    if [ "$name" != "" ]; then
        tar cvjf $1.tar.bz2 $1
    fi
}

# escape potential tarbombs
# http://www.commandlinefu.com/commands/view/6824/escape-potential-tarbombs
untar() {
	l=$(tar tf $1);
	if [ $(echo "$l" | wc -l) -eq $(echo "$l" | grep $(echo "$l" | head -n1) | wc -l) ]; then
        tar xf $1;
	else
        mkdir ${1%.t(ar.gz||ar.bz2||gz||bz||ar)} && tar xvf $1 -C ${1%.t(ar.gz||ar.bz2||gz||bz||ar)};
	fi
}

# backup a file with a timestamp
# http://www.commandlinefu.com/commands/view/7294/backup-a-file-with-a-date-time-stamp
bak () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y-%m-%d);
        firstpart=`echo $oldname | cut -d "." -f 1`;
        newname=`echo $oldname | sed s/$firstpart/$firstpart.$datepart/`;
        cp -R ${oldname} ${newname};
    fi
}

# rename files in a directory in an edited list fashion
# http://www.commandlinefu.com/commands/view/7818/
massmove () {
    ls > ls; paste ls ls > ren; vi ren; sed 's/^/mv /' ren|bash; rm ren ls
}

echoAndRun() {
    echo "$@"
    "$@"
}

##############################################################
# DEBUGGING
##############################################################

printHookFunctions () {
    print -C 1 ":::pwd_functions:" $chpwd_functions
    print -C 1 ":::periodic_functions:" $periodic_functions
    print -C 1 ":::precmd_functions:" $precmd_functions
    print -C 1 ":::preexec_functions:" $preexec_functions
    print -C 1 ":::zshaddhistory_functions:" $zshaddhistory_functions
    print -C 1 ":::zshexit_functions:" $zshexit_functions
}

# reloads all functions
# http://www.zsh.org/mla/users/2002/msg00232.html
reloadFunctions() {
    local f=($ZSH_CONFIG_HOME/functions/*(.))
    unfunction $f:t 2> /dev/null
    autoload -Uz $f:t
}


# TODO
# query Wikipedia via console over DNS
# translate via google language tools
