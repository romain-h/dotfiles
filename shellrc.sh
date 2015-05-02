## Shell Init

# Set path to root of dotfiles
DOTFILES="$HOME/.dotfiles"

# Load main dotfiles
DOTSHELL="$DOTFILES/shell"
if [ -f "$DOTSHELL/_main.sh" ]; then
  source "$DOTSHELL/_main.sh"
fi
