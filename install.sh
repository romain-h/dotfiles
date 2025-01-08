#!/usr/bin/env bash

TARGET="$HOME"
BIN="/usr/local/bin"
HOME_SYMLINKS="alacritty bat git nvim ripgrep shell tmux"
BIN_SYMLINKS="bin"

BREW_LIST="bat bc curl exif exiftool ffmpeg fzf git gnu-sed \
    go graphviz htop hub imagemagick irssi jq mkcert node pandoc \
    rename ripgrep shellcheck shfmt stow \
    tmux neovim vim wget zsh"

BREW_LIST_CASK="alacritty calibre font-commit-mono-nerd-font rectangle spotify slack"

prompt_confirm() {
  while true; do
    read -r -p "Are you sure? [y/N] " input

    case $input in
    [Yy][Ee][Ss] | [Yy]) # Yes or Y (case-insensitive).
      return 0
      break
      ;;
    [Nn][Oo] | [Nn]) # No or N.
      return 1
      break
      ;;
    *) ;;

    esac
  done
}

install_symlinks() {
  # We need GNU Stow
  if [ ! "$(command -v stow)" ]; then
    install_brew
    brew install stow
  fi

  echo "Linking to $TARGET directory"
  stow -nvRt $TARGET $HOME_SYMLINKS
  prompt_confirm
  if [ $? == 0 ]; then
    stow -vRt $TARGET $HOME_SYMLINKS
  fi

  echo "Linking to $BIN directory"
  stow -nvt $BIN $BIN_SYMLINKS
  prompt_confirm
  if [ $? == 0 ]; then
    stow -vt $BIN $BIN_SYMLINKS
  fi
}

install_brew() {
  if [ ! "$(command -v brew)" ]; then
    echo "Installing Homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_zsh() {
  if [ ! "$(command -v zsh)" ]; then
    install_brew
    brew install zsh
  fi

  if [ ! "$(command -v git)" ]; then
    install_brew
    brew install git
  fi

  # install oh-my-zsh
  if [ ! -r "$TARGET/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_vim() {
  brew install neovim
  nvim --headless "+Lazy! sync" +qa
}

install_dev_tools() {
  brew install $BREW_LIST
  brew install --cask $BREW_LIST_CASK
}

refresh_system() {
  brew update
  brew upgrade $BREW_LIST
  brew upgrade --cask

  nvim --headless "+Lazy! sync" +qa
}

install_initials() {
  install_brew
  install_zsh
  install_dev_tools

  install_symlinks
  install_vim

  echo "🍺  Installation: Done!"
}

show_help() {
  echo 'usage: ./install.sh [command] -- Dotfiles installation'
  echo 'COMMANDS:'
  echo '          init: Initial setup on new machine'
  echo '      symlinks: Install symlinks for various dotfiles into target directory.'
  echo '      homebrew: Install Homebrew'
  echo '           vim: Install Vim and vimrc'
  echo '          tmux: Install tmux'
  echo '      devtools: Install dev tools (curl, wget, rg, htop...)'
  echo 'refresh_system: Upgrade all packages and vim plugs'
  exit
}

case "$1" in
init)
  install_initials
  ;;
symlinks | links)
  install_symlinks
  ;;
homebrew)
  install_brew
  ;;
vim)
  install_vim
  ;;
tmux)
  install_tmux
  ;;
devtools)
  install_dev_tools
  ;;
refresh_system)
  refresh_system
  ;;
*)
  show_help
  ;;
esac
