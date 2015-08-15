#! /usr/bin/env bash
## Configuration
TARGET="$HOME/.vim"
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# run with bash -> the path may be different than the one you have in zshrc if you are using zsh
echo "Start vim installation"
if [ -r $TARGET] && [ ! -r "$TARGET.orig" ]; then
  mv $TARGET "$TARGET.orig"
fi

# install vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# Add some folders for swap, bakcup and undo files
mkdir -p $TARGET/tmp/backup
mkdir -p $TARGET/tmp/swap
mkdir -p $TARGET/tmp/undo

# Symlink ultisnips
ls -s "$DIR/UltiSnips" "$TARGET/UltiSnips"

# install all vundle bundles
vim +'silent! PluginInstall' +qall
