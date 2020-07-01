# Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$DOTFILES/oh-my-zsh"
ZSH_THEME="skagen"

# Plugins
plugins=( \
  tmux \
  vi-mode \
)

# Source main OMZSH script
source "$ZSH/oh-my-zsh.sh"

## Custom vi keybinding

# shift-tab
if [[ -n $terminfo[kcbt] ]]; then
  bindkey "$terminfo[kcbt]" reverse-menu-complete
fi

# delete
if [[ -n $terminfo[kdch1] ]]; then
  bindkey          "$terminfo[kdch1]" delete-char
  bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
fi

# backspace (and <C-h>)
if [[ -n $terminfo[kbs] ]]; then
  bindkey          "$terminfo[kbs]" backward-delete-char
  bindkey -M vicmd "$terminfo[kbs]" backward-char
fi

bindkey           '^H' backward-delete-char
bindkey -M vicmd  '^H' backward-char

# Keep retro compat with incremental search
bindkey "^R" history-incremental-search-backward

# Kill the lag with [esc]...
export KEYTIMEOUT=1

# FZF
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
