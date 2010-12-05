#!/bin/zsh
# Based on http://stuff.mit.edu/~jdong/misc/zshrc 

# next lets set some enviromental/shell pref stuff up
# setopt NOHUP
#setopt NOTIFY
#setopt NO_FLOW_CONTROL
# setopt AUTO_LIST      # these two should be turned off
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME    # tries to resume command of same name
unsetopt BG_NICE        # do NOT nice bg commands
setopt CORRECT          # command CORRECTION
# setopt HASH_CMDS      # turns on hashing
#
setopt MENUCOMPLETE
setopt ALL_EXPORT
setopt PROMPT_SUBST

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

PATH="/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
TZ="America/New_York"
HOSTNAME="`hostname`"
PAGER='less'

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

#LANGUAGE=
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LC_CTYPE=C

unsetopt ALL_EXPORT

autoload -U compinit
compinit

bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "${PR_BLUE}completing ${PR_YELLOW}%d%b%u"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "%B${PR_RED}No match for ${PR_NO_COLOR}%d%b"
zstyle ':completion:*:corrections' format "%B${PR_BLUE}%d ${PR_RED}(errors: %e)%b"
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull  \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd     \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd  \
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail \
        firebird gnats haldaemon hplip irc klog list man cupsys postfix       \
        proxy syslog www-data mldonkey sys snort
# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

# MAKE
alias make="make -j8"
# mr args... = make args... && run. 
# Gentoo seems to need run to be executed in its own FS, 
# so copy it there, but clean up afterwords.
mr() {
    make "$@" && cp run ~/run && ~/run && rm ~/run
}

# Clean up what mr creates.
mc() {
    rm ~/run ./run
}

# PROMPTS
source ~/.zsh/functions/prompt.zsh

# HISTORY
HISTFILE=$HOME/.zhistory
HISTSIZE=2000
SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups # If cmd is a duplicate, remove the old one from history.
setopt hist_save_no_dups    # Don't write to HISTFILE if cmd is duplicate.
setopt hist_find_no_dups    # If duplicates exist, don't find them.

setopt histreduceblanks # $  cd  file -> $ cd file
setopt appendhistory
setopt inc_append_history share_history
setopt append_history
setopt hist_no_store # Don't store history commands.
unsetopt extended_history  # Don't keep timestamps in the history.
unsetopt hist_ignore_space # Keep commands starting with space.

# EDITOR
EDITOR='vim'
alias -s cpp=vim
alias -s h=vim

if [ $SSH_TTY ]; then
    MUTT_EDITOR=vim
else
    MUTT_EDITOR=emacsclient.emacs-snapshot
fi

# MISC
setopt always_last_prompt

alias ls="ls --color --group-directories-first"
alias -s html=chromium
alias -s com=chromium

# Go setup
export GOROOT=$HOME/go/src
export GOARCH=386
export GOOS=linux
export GOBIN=$HOME/go/bin
PATH+=:${GOBIN}
# Enable automatic rehash of commands
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1   # Because we didn't really complete anything
}
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete 
