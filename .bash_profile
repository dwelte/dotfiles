source /usr/share/git-core/git-completion.bash

export GITPS1SHOWDIRTYSTATE=true
RED="\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
NORMAL="\[\033[0;0m\]"

export PS1='\[\033[0;31m\][\u@\h \[\033[0;33m\]\W$(__git_ps1 " (%s)")]\$\[\033[0;0m\] '
