#!/bin/zsh

autoload -Uz vcs_info

# Many color options are used, so make short abbreviations.
BLU=$PR_BLUE
YEL=$PR_YELLOW
GRN=$PR_GREEN
RED=$PR_RED
CYN=$PR_CYAN
 NO=$PR_NO_COLOR

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
# %s - the svn client
FMT_BRANCH="${YEL}(%s)${NO} ${RED}%r${NO}::${YEL}%b${RED}%u${BLU}%c" # i.e. (git) base-dir::master[unstaged][staged]
FMT_ACTION="${NO}(${CYN}%a${NO}%)"   # e.g. (rebase-i)
FMT_PATH="%R${YEL}/%S"              # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories    
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '!!!'  # display !!! if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '*'    # display * if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"              "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"        

function precmd {       
    vcs_info 'prompt'         
}      

function lprompt {
    local cwd="%1~"
    PROMPT="${RED}${cwd}${GRN}$ ${NO}"
}                                                                                        
 
function rprompt {
    local git='$vcs_info_msg_0_'                          
    RPROMPT="${YEL}${git}${NO}"
}
 
lprompt
rprompt
