# Use git prompt
if is_osx; then
  # from Brew
  source /usr/local/etc/bash_completion.d/git-prompt.sh
  PROMPT='%{$FG[136]%}%n%{$FG[110]%}@%{$reset_color%}%{$FG[154]%}%m:%{$reset_color%}%{$FG[075]%}%~%{$reset_color%}%{$FG[011]%}$(__git_ps1 " (%s)")%{$reset_color%} %(!.#.$) '
else
  source /etc/bash_completion.d/git-prompt
  PROMPT='%{$FG[162]%}%n%{$FG[148]%}@%{$reset_color%}%{$FG[153]%}%m:%{$reset_color%}%{$FG[075]%}%~%{$reset_color%}%{$FG[011]%}$(__git_ps1 " (%s)")%{$reset_color%} %(!.#.$) '
fi

# Export some params for git prompt Brew
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1

