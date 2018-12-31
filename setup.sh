#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

if [ -d $DOTFILES_PATH ]; then
	echo "dotfiles: already exists"
else
	echo "Downloading dotfiles..."
	if type git > /dev/null 2>&1; then
		git clone https://github.com/Pierrotica/dotfiles.git
	else
		curl -sL https://github.com/Pierrotica/dotfiles/archive/master.tar.gz | tarxz
		mv dotfiles-master dotfiles
	fi
	echo "successfully downloaded"
fi
"
