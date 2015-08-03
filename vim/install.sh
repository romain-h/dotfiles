#! /usr/bin/env bash
## Configuration
TARGET="$HOME/.vim"
CWD=$(pwd)

# run with bash -> the path may be different than the one you have in zshrc if you are using zsh
echo "Start vim installation"
if [ -r $TARGET] && [ ! -r "$TARGET.orig" ]; then
  mv $TARGET "$TARGET.orig"
fi

# install vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# Add some folders for swap, bakcup and undo files
mkdir -p ~/.vim/tmp/backup
mkdir -p ~/.vim/tmp/swap
mkdir -p ~/.vim/tmp/undo

# Symlink ultisnips
ls -s "$CWD/vim/UltiSnips" "$TARGET/UltiSnips"

# install all vundle bundles
vim -c +BundleInstall +qall
