function preexec() {
	echo $$ $USER `date +%s` "$1" >> $HOME/.zsh_eternal_history
}

# Function to make searching the history easier
function hgrep {
	grep $@ ~/.zsh_eternal_history
}
