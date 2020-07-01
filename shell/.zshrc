export EDITOR="vim"
export VISUAL=$EDITOR

ZSH="$HOME/.oh-my-zsh"

if [ -f "$HOME/.shell/prompt" ]; then
  source $HOME/.shell/prompt
fi

# Plugins
plugins=( \
  tmux \
  vi-mode \
)

# Source main OMZSH script
source "$ZSH/oh-my-zsh.sh"

if [ -f "$HOME/.shell/vi-mode" ]; then
  source $HOME/.shell/vi-mode
fi

if [ -f "$HOME/.shell/tools" ]; then
  source $HOME/.shell/tools
fi

if [ -f "$HOME/.shell/path" ]; then
  source $HOME/.shell/path
fi

# Source custom env that will not be tracked
if [ -f "$HOME/.env_custom" ]; then
  source $HOME/.env_custom
fi

