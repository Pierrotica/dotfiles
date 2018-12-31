#!/bin/bash

#Load utils
. $HOME/dotfiles/setup/utils.sh

print_title "XCode"

if [ -d "$(xcode-select -p)" ]; then
	print_warning "xcode-select: already installed"
else
	xcode-select --install
fi
