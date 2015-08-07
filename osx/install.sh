#!/usr/bin/env bash

# Install Jumpcut
curl -L http://downloads.sourceforge.net/jumpcut/Jumpcut_0.63.tgz > /var/tmp/jumpcut.tgz && tar -xf /var/tmp/jumpcut.tgz && mv /var/tmp/Jumpcut.app /Applications/

# Remove actual preferences
defaults delete com.googlecode.iterm2

# cp ~/Library/Preferences
cp -r Preferences/ ~/Library/Preferences

# Read Pref to empty cache
defaults read -app iTerm
defaults read -app Jumpcut

# TODO add to default login
# Install fonts http://www.fontsquirrel.com/fonts/download/Liberation-Mono
