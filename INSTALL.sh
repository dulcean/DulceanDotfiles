!#/bin/bash

clear

#==========================
#	REPOSITORY
#==========================

repo="dulcean/DulceanDotfiles"

#==========================
#     DOWNLOAD FOLDER
#==========================

download_folder="$HOME/.dulcean"
if [ ! -d $download_folder ]; then
	mkdir -p $download_folder
fi

#==========================
#	  PACKAGES
#==========================

_isInstalled() {
	package="$1"
	check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
	if [ -n "${check}" ]; then
		echo 0
        	return
	fi
	echo 1
	return
}

_installPackages() {
	toInstall=()
	for pkg; do
		if [[ $(_isInstalled "${pkg}") == 0 ]]; then
			echo ":: ${pkg} is already installed."
			continue
        	fi
        	toInstall+=("${pkg}")
	done
	if [[ "${toInstall[@]}" == "" ]]; then
		return
	fi
	printf "Package not installed:\n%s\n" "${toInstall[@]}"
	sudo pacman --noconfirm -S "${toInstall[@]}"
}

_installParu() {
	_installPackages "base-devel"
	SCRIPT=$(realpath "$0")
	temp_path=$(dirname "$SCRIPT")
	git clone https://aur.archlinux.org/paru.git $download_folder/paru
	cd $download_folder/paru
	makepkg -si
	cd $temp_path
	echo ":: PARU HAS BEEN INSTALLED SUCCESSFULLY"
}

packages={
	"wget",
	"unzip",
	"gum",
	"rsync",
	"git"
}

#==========================
#	  COLORS
#==========================
GREEN='\033[0;32m'
NONE='\033[0m'


#==========================
#	  HEADER
#==========================
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF

echo "DULCEAN =|= DOTFILES =|= INSTALLER"
echo -e "${NONE}"

while true; do
	read -p "Start Installation Now? (Y(y)/N(n)): " yn
	case $yn in
		[Yy]*)
			echo ":: Installation started."
			echo
			break
			;;
		[Nn]*)
			echo ":: Installation canceled."
			exit
			break
			;;
		*)
			echo ":: Enter Yes or No"
			;;
	esac
done


