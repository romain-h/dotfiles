#!/bin/bash

# run with bash -> the path may be different than the one you have in zshrc if you are using zsh
echo "Start vim installation"
if [ -r ~/.vim ] && [ ! -r ~/.vim.orig ]; then
  mv ~/.vim ~/.vim.orig
fi

# Get current working directory
CWD=$(pwd)

# install Neobundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# Add some folders for swap, bakcup and undo files
mkdir -p ~/.vim/tmp/{backup,swap,undo}

while true; do
    read -p "[vim install] Do you want to select vim plugin to install? [Y/n]" yn
    case $yn in
        [Yy]* ) vim ~/.vimrc; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# install all bundles
vim +NeoBundleInstall +qall
