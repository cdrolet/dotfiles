if [[ "$OSTYPE" != darwin* ]]; then
  return 1
fi

##############################################################
# FUNCTIONS
##############################################################

# Start a webcam for screencast
function webcam () {
    mplayer -cache 128 -tv driver=v4l2:width=350:height=350 -vo xv tv:// -noborder -geometry "+1340+445" -ontop -quiet 2>/dev/null >/dev/null
}

##############################################################
# ALIAS
##############################################################

# Flush the DNS on Mac
alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'


# Copy and paste and prune the useless newline
alias pbcopynn='tr -d "\n" | pbcopy'
