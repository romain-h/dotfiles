# PROMPT="[%*] %n:%c $(git_prompt_info)%(!.#.$) "
# PROMPT='[%*] %{$fg[cyan]%}%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) '

# Use git prompt installed by Brew
source /usr/local/etc/bash_completion.d/git-prompt.sh

# Export some params for git prompt Brew
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
## Romain Zsh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  PROMPT='%{$FG[124]%}%n%{$FG[126]%}@%{$reset_color%}%{$FG[128]%}%m:%{$reset_color%}%{$FG[075]%}%~%{$reset_color%}%{$FG[011]%}$(__git_ps1 " (%s)")%{$reset_color%} %(!.#.$) '
else
  PROMPT='%{$FG[136]%}%n%{$FG[110]%}@%{$reset_color%}%{$FG[154]%}%m:%{$reset_color%}%{$FG[075]%}%~%{$reset_color%}%{$FG[011]%}$(__git_ps1 " (%s)")%{$reset_color%} %(!.#.$) '
fi

## Old params for ZSH git prompt
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[011]%} ("
# ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
