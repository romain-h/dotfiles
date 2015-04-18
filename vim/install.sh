#!/bin/bash

# run with bash -> the path may be different than the one you have in zshrc if you are using zsh
echo "Start vim installation"
if [ -r ~/.vim ] && [ ! -r ~/.vim.orig ]; then
  mv ~/.vim ~/.vim.orig
fi

# Get current working directory
CWD=$(pwd)

# install vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# Add some folders for swap, bakcup and undo files
mkdir -p ~/.vim/tmp/{backup,swap,undo}

# Symlink ultisnips
ls -s ${CWD}/vim/UltiSnips ~/.vim/UltiSnips

while true; do
    read -p "[vim install] Do you want to select vim plugin to install? [Y/n]" yn
    case $yn in
        [Yy]* ) vim ~/.vimrc; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# install all vundle bundles
vim +BundleInstall +qall
