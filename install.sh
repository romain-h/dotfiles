#!/usr/bin/env bash

TARGET="$HOME"
BIN="/usr/local/bin"
HOME_SYMLINKS="alacritty bat direnv git nvim ripgrep shell tmux vim"
BIN_SYMLINKS="bin"

BREW_LIST="asdf bat bc clipper curl exif exiftool ffmpeg fzf git gnu-sed \
    graphviz htop imagemagick irssi jq mkcert neofetch pandoc \
    reattach-to-user-namespace rename ripgrep shellcheck shfmt stow \
    tmux vim wget zsh"

BREW_LIST_CASK="alacritty rectangle"

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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
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
    git clone git://github.com/ohmyzsh/ohmyzsh.git "$TARGET/.oh-my-zsh"
    chsh -s "$(command -v zsh)"
  fi
}

install_vim() {
  brew install vim

  # install Plug
  if [ ! -f "$TARGET/.vim/autoload/plug.vim" ]; then
    curl -fLo "$TARGET/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # install all plugins
  vim +'silent! PlugInstall' +qall
}

install_dev_tools() {
  brew install $BREW_LIST
  brew cask install $BREW_LIST_CASK
}

refresh_system() {
  vim +PlugUpdate +qall

  brew update
  brew upgrade $BREW_LIST
  brew cask upgrade
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
