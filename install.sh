#!/bin/bash

echo "Dotfiles install ..."
usage="$(basename "$0") [-h] [-s n] -- Install or update dotfiles

where:
    -h  this help
    -u  update mode. Will add only new dotfile"

updateMode=false
while getopts ':hu:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    u) updateMode=true
       ;;
  esac
done
shift $((OPTIND - 1))

# Get current working directory
CWD=$(pwd)

# Mains files arrays
# create arrays
declare -a confFiles=(
  ack/ackrc
  git/gitconfig
  git/gitignore
  oh-my-zsh/romain.zsh-theme
  tmux/tmux.conf
  vim/vimrc
  zsh/zshrc
)

declare -a dests=(
  ~/.ackrc
  ~/.gitconfig
  ~/.gitignore
  ~/.oh-my-zsh/themes/romain.zsh-theme
  ~/.tmux.conf
  ~/.vimrc
  ~/.zshrc
)

isOsx=false
# OsX detection
if [ "$OSTYPE" == "darwin"*  ] ; then
    isOsx=true
fi

# Update mode. Will test symlinks and install missing one
if [ "$updateMode" = true ] ; then
    echo "running update mode ..."

    for i in ${!confFiles[@]}; do
        confFile=${confFiles[$i]}
        dest=${dests[$i]}

        # check for existing symlink
        if [! -L ${dest} ] ; then
            rm ${dest}

            # create symlink
            ln -s ${CWD}/${confFile} ${dest}

            echo "${dest} installed!"
        fi

    done

    exit 0
fi # End updateMode


## Fresh install
# Is zsh installed already?
if [ "$(which zsh)" == '' ] ; then
    if [ "$isOsx" = true ] ; then
        brew install zsh
    else
        apt-get install zsh
    fi
fi

# install oh-my-zsh
if [ ! -r ~/.oh-my-zsh ]; then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi


# Get current working directory
CWD=$(pwd)

# create all the files
for i in ${!confFiles[@]}; do
  confFile=${confFiles[$i]}
  dest=${dests[$i]}

  # check for existing files and back them up
  if [ -f ${dest} ] && [ ! -f ${dest}.orig ]; then
    mv ${dest} ${dest}.orig
  elif [ -h ${dest} ]; then
    rm ${dest}
  fi

  # create symlink
  ln -s ${CWD}/${confFile} ${dest}

  echo "${dest} installed!"
done

# install vim
sh vim/install.sh

# create custom env file
touch ~/.env_custom

# Test zsh install and switch to it for the current  user

chsh -s $(which zsh)
echo -e "\xF0\x9F\x8D\xBA Installation: Done!"