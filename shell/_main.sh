##
# Main Shell Setup
##

# Set required path variables
DOTBIN="$DOTFILES/bin"

# Helper Functions
source "$DOTSHELL/detect-os.sh"

# Load bash or zsh specific init files
if [ -n "$BASH_VERSION" ]; then
  source "$DOTSHELL/bashrc.sh"
elif [ -n "$ZSH_VERSION" ]; then
  source "$DOTSHELL/zshrc.sh"
fi

# Environment Setup
source "$DOTSHELL/env.sh"
