#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

check_os() {
	os_name="$(uname)"
	if [ "$os_name" != "Darwin" ]; then
		echo "Sorry, this script is intended only for macOS"
		exit 1
	fi
}

download_dotfiles() {
	echo "Download dotfiles"
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
}

main () {
	check_os
	download_dotfiles

	. $DOTFILES_PATH/setup/symbolic_links.sh	
	. $DOTFILES_PATH/setup/install.sh
	. $DOTFILES_PATH/setup/changeLoginShell.sh
}
main

