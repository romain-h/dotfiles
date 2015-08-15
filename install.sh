#!/usr/bin/env bash

sudo -v

# Keep-alive: update existing `sudo` time stamp until `.install` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
NOW=$(date +%b_%d_%y_%H%M%S)
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
source "$DIR/shell/detect-os.sh"

## Main Functions

install_symlinks () {
  if [ ! -d "$SYMLINK_PATH/.backup/$NOW" ]; then
    mkdir -p $SYMLINK_PATH/.backup/$NOW
  fi
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

  # create custom env file
  if [ ! -f "$TARGET/.env_custom" ]; then
    touch "$TARGET/.env_custom"
  fi
}

install_brew () {
  if [ ! $(which brew) ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

install_zsh () {
  if [ ! $(which zsh) ]; then
    if is_osx; then
      brew install zsh
    else
      sudo apt-get install -y zsh
    fi
  fi

  # install oh-my-zsh
  if [ ! -r ~/.oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git $TARGET/.oh-my-zsh
    sudo chsh -s $(which zsh) $USER # make it default
  fi
}

install_tmux () {
  if is_osx; then
    brew install tmux
  else
    sudo apt-get install -y python-software-properties

    if [ ! -f /etc/apt/sources.list.d/pi-rho-dev-precise.list ]; then
      sudo add-apt-repository ppa:pi-rho/dev -y
      sudo apt-get update
    fi

    sudo apt-get install -y tmux
  fi
}

install_vim () {
  TARGET_VIM="$HOME/.vim"
  if is_osx; then
    brew install vim --override-system-vi
  else
    sudo apt-get install -y python-software-properties

    if [ ! -f /etc/apt/sources.list.d/fcwu-tw-ppa-precise.list ]; then
      sudo add-apt-repository ppa:fcwu-tw/ppa -y
      sudo apt-get update
    fi

    sudo apt-get install -y vim
  fi

  # install vundle
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

  # Add some folders for swap, bakcup and undo files
  mkdir -p $TARGET_VIM/tmp/backup
  mkdir -p $TARGET_VIM/tmp/swap
  mkdir -p $TARGET_VIM/tmp/undo

  # Symlink ultisnips
  ls -s "$DIR/vim/UltiSnips" "$TARGET_VIM/UltiSnips"

  # install all vundle bundles
  vim +'silent! PluginInstall' +qall
}

install_ag () {
  if [ ! $(which ag) ]; then
    if is_osx; then
      brew install the_silver_searcher
    else
      sudo apt-get install -y automake make pkg-config libpcre3-dev zlib1g-dev liblzma-dev

      AGDIR=/tmp/the_silver_searcher

      git clone git://github.com/ggreer/the_silver_searcher.git $AGDIR
      cd $AGDIR

      ./build.sh
      sudo make install

      rm -rf $AGDIR
      cd
    fi
  fi
}

install_dev_tools () {
  if is_osx; then
    brew install curl wget ctags htop
  else
    sudo apt-get install -y curl wget exuberant-ctags htop
  fi
  install_ag
}

install_initials () {
  install_dev_tools

  if is_osx; then
    install_brew
    brew install git
  else
    sudo apt-get install -y git
  fi

  install_symlinks
  install_zsh
  install_vim
  install_tmux

  echo "🍺  Installation: Done!"
}

## Helper functions

symlink () {
  if [ ! -e "$2" ]; then
    echo "   symlink: $2 --> $1"
    ln -s "$1" "$2"
  else
    if [ ! -L "$2" ]; then
      echo "   backup $2 into $SYMLINK_PATH/.backup/$NOW"
      mv $2 $SYMLINK_PATH/.backup/$NOW/
      ln -s "$1" "$2"
    fi
    echo "   exists: $2"
  fi
}

show_help () {
  echo 'usage: ./install.sh [command] -- Dotfiles installation'
  echo 'COMMANDS:'
  echo '          init: Initial setup on new machine'
  echo '      symlinks: Install symlinks for various dotfiles into' \
    'target directory.'
  echo '      homebrew: Install Homebrew (Mac OS X only).'
  echo '           vim: Install vim and vimrc'
  echo '          tmux: Install tmux'
  echo '      devtools: Install dev tools (curl, wget, ag, htop...)'
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
  *)
    show_help
    ;;
esac
