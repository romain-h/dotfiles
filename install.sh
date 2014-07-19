#!/bin/sh

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
  vim/vimrc
  zsh/zshrc
)

declare -a dests=(
  ~/.ackrc
  ~/.gitconfig
  ~/.gitignore
  ~/.oh-my-zsh/themes/romain.zsh-theme
  ~/.vimrc
  ~/.zshrc
)

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

    exit
fi # End updateMode

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

echo -e "\xF0\x9F\x8D\xBA Installation: Done!"
