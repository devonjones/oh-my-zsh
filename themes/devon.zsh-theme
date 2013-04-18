# vim:ft=zsh ts=4 sw=4 sts=4
#if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi
#
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
#
#PROMPT='%m %{${fg_bold[blue]}%}:: %{$reset_color%}%{${fg[green]}%}%3~ $(git_prompt_info)%{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%} '
#
#RPS1="${return_code}"
#
#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
#ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.

prompt_segment() {
	local fg
	[[ -n $1 ]] && fg="$1"
	echo -n "%{$fg%}"
	[[ -n $2 ]] && echo -n $2
	echo -n "%{$reset_color%}"
}

prompt_virtualenv() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		prompt_segment "%{$fg_bold[red]%}" "(`basename $VIRTUAL_ENV`) "
	fi
}
VIRTUAL_ENV_DISABLE_PROMPT=true

prompt_aws() {
	if [[ -n "$AWS_ACCOUNT" ]]
	then
		prompt_segment "%{$fg_bold[white]%}" "[${AWS_ACCOUNT}] "
	fi
}

prompt_user() {
	local user_color='green'
	test -n "$SSH_CLIENT" && user_color='cyan'
	test $UID -eq 0 && user_color='red'
	local host_color="$user_color"
	test -n "$SSH_CLIENT" && host_color='cyan'
	prompt_segment "%{$fg_bold[$user_color]%}" "%n"
	prompt_segment "%{$fg_bold[$host_color]%}" "@%m "
}

prompt_exit() {
	exit_color="white"
	[[ $RETVAL -ne 0 ]] && exit_color="red"
	prompt_segment "%{$fg_bold[$exit_color]%}" "$RETVAL "
}

prompt_dir() {
	dircolor="%{$fg_bold[blue]%}"
	if [[ $INGIT -eq 1 ]] ; then
		cdup=`git rev-parse --show-cdup 2> /dev/null`
		color="%{$fg_bold[magenta]%}"
		git diff --quiet HEAD &>/dev/null 
		if [[ $? == 1 ]]
		then
			color="%{$fg[red]%}"
		fi
		dir=$(cd "$cdup";pwd)
		pdir=`pwd`
		retract=${dir/$HOME/\~}
		gitdir="${pdir/$dir/}/"
		echo -n "$dircolor$retract$color$gitdir%{$reset_color%} "
	else
		prompt_segment $dircolor '%~ '
	fi
}

prompt_git() {
	if [[ $INGIT -eq 1 ]] ; then
		ZSH_THEME_GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
		ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[white]%}>%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[white]%}<%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}m%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
		echo -n "$(git_prompt_info)$(git_prompt_status)"
		INDEX=$(git status --porcelain 2> /dev/null)
		if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
			prompt_segment "%{$fg_bold[green]%}" "s"
		fi
		if [[ -n "$(git stash list 2> /dev/null | head -n 1 )" ]]; then
			prompt_segment "%{$fg_bold[yellow]%}" "\$"
		fi
		prompt_segment "" " "
	fi
}

## Main prompt
build_prompt() {
	RETVAL=$?
	INGIT=0
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		INGIT=1
	fi
	prompt_virtualenv
	prompt_aws
	prompt_user
	prompt_exit
	prompt_dir
	prompt_git
	prompt_segment "%{$fg_bold[blue]%}" "\$"
	#prompt_status
	#prompt_context
	#prompt_dir
	#prompt_hg
	#prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '

