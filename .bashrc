# .bashrc

export HISTCONTROL=ignoredups # Don't put duplicate lines in the history.

BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m' # No Color


if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion

    # Extend completion to totem.
    _totem() 
    {
        COMPREPLY=()

        local cur="${COMP_WORDS[COMP_CWORD]}"
        local prev="${COMP_WORDS[COMP_CWORD-1]}"

        # Let completion for options be with or without --. (Convenience)
        # TODO: I should only have to maintain one list.
        local opts="play enqueue next previous"
        local __opts="--play --enqueue --next --previous"

        if [[ $cur == --* ]] ; then 
            COMPREPLY=(   $(compgen -W "$__opts" -- $cur) ) 
        else
            # If COMPREPLY is left empty, it will complete files, but if the --
            # is added here and cur doesn't match with an option, it won't. Use
            # tmp to avoid clobbering.
            local tmp=( --$(compgen -W "$opts"   -- $cur) )  
            if [[ $tmp != -- ]] ; then
                COMPREPLY=$tmp
            fi
        fi

        return 0
    } 
    complete -f -F _totem totem
fi # bash completion

#######################
# Comand prompt 
#######################

# All these are from http://asemanfar.com/Current-Git-Branch-in-Bash-Prompt
# Slightly modified, too!
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ git::\1/'
}

parse_svn_branch() {
  parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn::"$1 "/" $2 ")"}'
}

parse_svn_url() {
  svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
}

parse_svn_repository_root() {
  svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
}

# I don't include the user since i've never once needed it.
PS1='\[\e[1;34m\]\W\[\e[2;33m\]\033[1m$(parse_git_branch)\033[0m\[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

###########################################
# Aliases
###########################################

alias ls="ls --color --group-directories-first"
alias make="make -j8"
alias try="make && ./run"
alias tryl="make && ./run && cat "

###########################################
# Functions
###########################################

# From http://tldp.org/LDP/abs/html/sample-bashrc.html
function extract() # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

source ~/.shell/cgroups
