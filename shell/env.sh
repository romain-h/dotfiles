# Use vim
export EDITOR="vim"
export VISUAL=$EDITOR

if is_osx; then
  # Brew path
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"

  # CLANG osX ...
  export CFLAGS=-Qunused-arguments
  export CPPFLAGS=-Qunused-arguments
fi

# Add dotfiles' bin directory to PATH
export PATH="$DOTBIN:$PATH"

# Source custom env that will not be tracked
if [ -f "$HOME/.env_custom" ]; then
  source $HOME/.env_custom
fi

# iTerm
if [ -f "$HOME/.iterm2_shell_integration.zsh" ]; then
  source "$HOME/.iterm2_shell_integration.zsh"
fi
