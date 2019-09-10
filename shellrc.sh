## Shell Init

# Set path to root of dotfiles
DOTFILES="$HOME/.dotfiles"

# Load main dotfiles
DOTSHELL="$DOTFILES/shell"
if [ -f "$DOTSHELL/_main.sh" ]; then
  source "$DOTSHELL/_main.sh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
