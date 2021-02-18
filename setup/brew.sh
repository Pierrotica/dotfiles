#!/bin/bash

# Load utils
. $HOME/dotfiles/setup/utils.sh

install_homebrew() {
	print_title "Homebrew"
	if type brew > /dev/null 2>&1; then
		print_warning "Homebrew: already installed"
	else
		print_message "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		print_success "successfully installed"
	fi

	print_message "brew update..."
	if brew update > /dev/null 2>&1; then
		print_success "successfully updated"
	else
		print_error "unsuccessfully updated"
	fi

	print_message "brew doctor..."
	if brew doctor > /dev/null 2>&1; then
		print_success "ready to brew"
	else
		print_error "not ready to brew"
	fi
}

install_packages() {
	print_title "Homebrew Packages"
	print_message "Installing packages..."
	packages=(
		wget curl zsh zsh-completions tmux reattach-to-user-namespace \
		openssl z ag lv nkf tree readline xz binutils coreutils \
		findutils proctools htop mobile-shell terminal-notifier \
		git hub tig gibo python python3 mercurial rbenv ruby-build \
		imagemagick plenv perl-build lua luajit ctags cscope cmigemo \
		source-highlight jq go ghq direnv peco sqlite mysql redis \
		socat arp-scan scala leiningen cabal-install packer gauche \
        rbenv-default-gems
	)
	for package in "${packages[@]}"; do
		if brew list "$package" > /dev/null 2>&1; then
			print_warning "$package: already installed"
		elif brew install $package > /dev/null 2>&1; then
			print_success "$package: successfully installed"
		else
			print_error "$package: unsuccessfully installed"
		fi
	done
	brew install vim --HEAD --with-gettext --with-override-system-vi
}

install_cask_packages() {
	print_title "Homebrew Cask Packages"
	packages=(
		iterm2 virtualbox vagrant vagrant-manager \
		github xquartz wireshark firefox appcleaner alfred \
		grandperspective steam qlcolorcode qlstephen qlmarkdown \
		quicklook-json qlprettypatch quicklook-csv betterzipql \
		webpquicklook suspicious-package link
	)
	for package in "${packages[@]}"; do
		if brew list "$package" > /dev/null 2>&1; then
			print_warning "$package: already installed"
		elif brew install $package > /dev/null 2>&1; then
			print_success "$package: successfully installed"
		else
			print_error "$package: unsuccessfully installed"
		fi
	done 
}

main() {
	install_homebrew
	install_packages
	install_cask_packages
}

main
