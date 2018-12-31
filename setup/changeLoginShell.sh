#!/bin/sh

# Load utils
. setup/utils.sh

change_login_shell() {
	print_title "Zsh"
	if [ $SHELL == $(which zsh) ]; then
		print_warning "Login shell: already zsh"
	else
		print_message "Changing login shell..."
		grep "$(which zsh)" /etc/shells &>/dev/null || sudo sh -c "echo $(which zsh) >> /etc/shells"
		chsh -s $(which zsh)
		print_success "successfully changed to zsh"
	fi
}

reboot_system() {
	print_title "Reboot System"
	printf "Do you want to reboot the system? (y/n) "
	read
	if [[ $REPLY =~ ^[Yy]$ || $REPLY == '' ]]; then
		sudo shutdown -r now &> /dev/null
	fi
}
main() {
	change_login_shell
	reboot_system
}

main

