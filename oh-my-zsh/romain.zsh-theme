# Use git prompt installed by Brew
source /etc/bash_completion.d/git-prompt

# Export some params for git prompt Brew
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1

PROMPT='%{$FG[136]%}%n%{$FG[110]%}@%{$reset_color%}%{$FG[154]%}%m:%{$reset_color%}%{$FG[075]%}%~%{$reset_color%}%{$FG[011]%}$(__git_ps1 " (%s)")%{$reset_color%} %(!.#.$) '
