
##############################################################
# FUNCTIONS
##############################################################

# show newest files
# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
newest () {
    fd --type f --exclude 'cache' --exclude '.hg' --exclude '.git' --changed-within 1d --exec stat -f "%Sm %N" {} \; | sort -r
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
    if [ -n "$1" ]; then
        cp -R "$1" "${1%.*}.$(date +%Y-%m-%d).${1##*.}"
    fi
}

# 1.Make shell scripts executable
# 2.Ensure directories are traversable
# 3.Set regular files to be readable by everyone but only writable by the owner
fixperms() {
    fd -t d -x chmod 755 {} \;
    fd -t f -x chmod 644 {} \;
    fd -t f -e sh -x chmod 755 {} \;
}

##############################################################
# ALIAS
##############################################################

# Recursive dos2unix in current directory
# Converts all files in the current directory and its subdirectories from DOS/Windows line endings (CRLF - \r\n) to Unix line endings (LF - \n).
alias dos2lf='dos2unix `find ./ -type f`'

# files used, anywhere on the filesystem
alias files.usage='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep'
# files being opened
alias files.open='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep open'
# files in use in the Users directory
alias files.usage.user='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep Users'

# Using modern tools
alias grep='rg'
alias find='fd'
alias cat='bat'
alias ls='eza'
alias l="eza -oAhtr --group-directories-first"
alias ll='eza -l'
alias la='eza -lah --git --group-directories-first --sort=size'
alias tree='eza --tree'
alias d='kitten diff'