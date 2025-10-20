# Modern HTTP client (xh - httpie alternative)
alias http='xh'
alias https='xh'
alias get='xh GET'
alias post='xh POST'
alias put='xh PUT'
alias delete='xh DELETE'

# Network connections
# Often useful to prefix with SUDO to see more system level network usage
alias network.connections='lsof -l -i +L -R -V'
alias network.established='lsof -l -i +L -R -V | grep ESTABLISHED'
alias network.internalip="ifconfig en0 | egrep -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'"
alias network.externalip='curl -s http://checkip.dyndns.org/ | sed "s/[a-zA-Z<>/ :]//g"'

# firewall management
alias port-forward-enable="echo 'rdr pass inet proto tcp from any to any port 2376 -> 127.0.0.1 port 2376' | sudo pfctl -ef -"
alias port-forward-disable="sudo pfctl -F all -f /etc/pf.conf"
alias port-forward-list="sudo pfctl -s nat"
