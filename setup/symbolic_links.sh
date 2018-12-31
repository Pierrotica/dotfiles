#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

create_links() {
	for file in .??*
	do
		filepath="${PWD}/${file}"

		[[ "$file" == ".git" ]] &&continue
		[[ "$file" == ".gitignore" ]] && continue
		[[ "$file" == ".DS_Store" ]] && continue
		[[ "$file" == "dein.toml" ]] && continue
		[[ "$file" == "dein_lazy.toml" ]] && continue

		ln -sfn $filepath $HOME/$file
		print_success "$HOME/$file -> $filepath"
	done
	mkdir -p ~/.vim/dein
	ln -sfn ${PWD}/dein.toml ~/.vim/dein/dein.toml
	ln -sfn ${PWD}/dein_lazy.toml ~/.vim/dein/dein_lazy.toml
}

main() {
	cd $DOTFILES_PATH
	print_title "create symbolic links"
	create_links
	cd ~
}

main
