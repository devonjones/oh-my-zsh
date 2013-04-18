# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
	alias la='ls -lAXh --color=always|less -R'
	alias diff='colordiff'
fi

