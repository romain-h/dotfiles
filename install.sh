#! /usr/bin/env bash

## Configuration
TARGET="$HOME"
DOTFILES_LINK=".dotfiles"
SYMLINK_PATH="$TARGET/$DOTFILES_LINK"
SYMLINKS_ORIG=( \
  agignore \
  gitconfig \
  gitignore \
  tmux.conf \
  vim/vimrc \
)
SYMLINKS_DEST=( \
  agignore \
  gitconfig \
  gitignore \
  tmux.conf \
  vimrc \
)
LOAD_FILES=(profile zshrc)

## Load helper
source "shell/detect-os.sh"

## Main Functions

install_symlinks () {
  # Symlink each path
  for i in ${!SYMLINKS_ORIG[@]}; do
    orig=${SYMLINKS_ORIG[$i]}
    dest=${SYMLINKS_DEST[$i]}
    symlink "$SYMLINK_PATH/$orig" "$TARGET/.$dest"
  done

  # Symlink shell init file for bash and zsh
  for i in ${LOAD_FILES[@]}; do
    symlink "$DOTFILES_LINK/shellrc.sh" "$TARGET/.$i"
  done
}

install_zsh () {
  if [ "$(which zsh)" == '' ] ; then
    if is_osx; then
      brew install zsh
    else
      apt-get install zsh
    fi
  else
    echo "ZSH already installed: $(which zsh)"
  fi
}

install_vim () {
  # install vim
  sh vim/install.sh
}

install_initials () {
  install_zsh # install zsh first
  chsh -s $(which zsh) # make it default

  # install oh-my-zsh
  if [ ! -r ~/.oh-my-zsh ]; then
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  fi

  # create custom env file
  if [ ! -f "$TARGET/.env_custom" ]; then
    touch "$TARGET/.env_custom"
  fi

  # install ag
  if is_osx; then
    brew install the_silver_searcher
  else
    apt-get install silversearcher-ag
  fi

  echo "🍺  Installation: Done!"
}

## Helper functions

symlink () {
  if [ ! -e "$2" ]; then
    echo "   symlink: $2 --> $1"
    ln -s "$1" "$2"
  else
    echo "    exists: $2"
  fi
}

show_help () {
  echo 'usage: ./install.sh [command] -- Dotfiles installation'
  echo 'COMMANDS:'
  echo '          init: Initial setup on new machine'
  echo '      symlinks: Install symlinks for various dotfiles into' \
    'target directory.'
  echo '      homebrew: Install Homebrew (Mac OS X only).'
  exit
}

case "$1" in
  init)
    install_initials
    ;;
  symlinks|links)
    install_symlinks
    ;;
  homebrew|brew)
    install_homebrew
    ;;
  *)
    show_help
    ;;
esac
