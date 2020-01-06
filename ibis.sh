#!/bin/bash

blue='\e[0;34'
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'

banner(){
	echo -e ""
	echo -e "$white    ______    _    $red ______            __    "
	echo -e "$white   /  _/ /_  (_)___$red/_  __/___  ____  / /____"
	echo -e "$white   / // __ \/ / ___/$red/ / / __ \/ __ \/ / ___/"
	echo -e "$white _/ // /_/ / (__  )$red/ / / /_/ / /_/ / (__  ) "
	echo -e "$white/___/_.___/_/____/$red/_/  \____/\____/_/____/  "
	echo -e "$white"
	main_menu
}

main_menu(){
	echo -e "$red 1)$white Install IbisLinux"
	echo -e "$red 2)$white Install Software"
	echo -e "$red 3)$white Install Some tools"
	echo -e "$red 4)$white Customize IbisLinux"
	echo -e "$red 5)$white Fix Script"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		install_ibislinux
	elif [[ $act == 2 ]]
	then
		gtk_software_menu
	elif [[ $act == 3 ]]
	then
		cli_software_menu
	elif [[ $act == 4 ]]
	then
		custom_menu
	elif [[ $act == 5 ]]
	then
		fix_menu
	fi
}

install_ibislinux(){
	echo -e ""
	if [[ $EUID -ne 0 ]]
	then
		echo -e " You are not root"
		exit 1
	fi
	echo -e "$red // Select partition to install IbisLinux"
	echo -e "$red // At least you must select 1 (one) partition"
	sleep 2
	fdisk -l
	read -p " ?? partition : " install_partition;
	read -p " ?? ibislinux iso : " ibis_image;
	echo -e ""
	echo -e "$okegreen ** Creating install directory on /tmp"
	mkdir -v /tmp/{ibis,sfs,iso}
	echo -e "$okegreen ** Mounting install partition on /tmp/ibis"
	mount -v $install_partition /tmp/ibis
	echo -e "$okegreen ** Mounting ibislinux iso on /tmp/iso"
	mount -o loop $ibis_image /tmp/iso
	echo -e "$okegreen ** Mounting system.sfs on /tmp/sfs"
	mount -v /tmp/iso/ibislinux/system.sfs /tmp/sfs
	echo -e "$okegreen ** Creating some ibislinux directory"
	mkdir -v /tmp/ibis/{dev,proc,sys,tmp,run}
	echo -e "$okegreen ** Installing ibislinux to $install_partition with rsync"
	rsync -av /tmp/sfs/* /tmp/ibis/
	echo -e "$okegreen ** Updating grub"
	update-grub
	echo -e ""
}

gtk_software_menu(){
	echo -e ""
	echo -e "$red 1)$white Install Firefox"
	echo -e "$red 2)$white Install Sublime"
	echo -e "$red 3)$white Install Telegram"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		install_firefox
	elif [[ $act == 2 ]]
	then
		install_sublime
	elif [[ $act == 3 ]]
	then
		install_telegram
	fi
}

install_firefox(){
	echo -e ""
	echo -e "$okegreen ** Downloading latest archive"
	wget https://ftp.mozilla.org/pub/firefox/releases/71.0/linux-x86_64/en-US/firefox-71.0.tar.bz2
	echo -e "$okegreen ** Extracting archive"
	tar -xvf firefox-71.0.tar.bz2
	echo -e "$okegreen ** Moving firefox to /opt/firefox"
	rm -rf /opt/firefox
	mv firefox /opt/
	echo -e ""
}

install_sublime(){
	echo -e ""
	echo -e "$okegreen ** Downloading latest archive"
	wget https://download.sublimetext.com/sublime_text_3_build_3211_x64.tar.bz2
	echo -e "$okegreen ** Extracting archive"
	tar -xvf sublime_text_3_build_3211_x64.tar.bz2
	echo -e "$okegreen ** Moving sublime to /opt/sublime_text_3"
	rm -rf /opt/sublime_text_3
	mv sublime_text_3 /opt/
	echo -e ""
}

install_telegram(){
	echo -e ""
	echo -e "$okegreen ** Downloading latest archive"
	wget https://updates.tdesktop.com/tlinux/tsetup.1.9.3.tar.xz
	echo -e "$okegreen ** Extracting archive"
	tar -xvf tsetup.1.9.3.tar.xz
	echo -e "$okegreen ** Moving telegram to /opt/Telegram"
	rm -rf /opt/Telegram
	mv Telegram /opt/Telegram
	echo -e ""
}

cli_software_menu(){
	echo -e ""
	echo -e "$red 1)$white Install Android platform-tools"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		install_platform_tools
	fi
}

install_platform_tools(){
	echo -e ""
	echo -e "$okegreen ** Downloading latest archive"
	wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip -o platform-tools.zip
	echo -e "$okegreen ** Extracting archive"
	unzip platform-tools.zip
	echo -e "$okegreen ** Moving platform-tools to /opt/platform-tools"
	rm -rf /opt/platform-tools
	mv platform-tools /opt/
	echo -e "$okegreen ** Adding PATH"
	echo "export PATH=/opt/platform-tools:$PATH" >> /etc/profile
	echo -e ""
}

custom_menu(){
	echo -e ""
	echo -e "$red 1)$white Install themes"
	echo -e "$red 2)$white Install iconpack"
	echo -e "$red 3)$white Set wallpaper"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		theme_menu
	elif [[ $act == 2 ]]
	then
		icon_menu
	elif [[ $act == 3 ]]
	then
		set_wallpaper
	fi
}

theme_menu(){
	echo -e ""
	echo -e "$red 1)$white Openbox themes collections"
	echo -e "$red 2)$white GTK themes collections"
	echo -e "$red 3)$white Tint2 themes collections"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		openbox_theme
	elif [[ $act == 2 ]]
	then
		gtk_theme
	elif [[ $act == 3 ]]
	then
		tint2_theme
	fi
}

openbox_theme(){
	echo -e ""
	echo -e "$okegreen ** Downloading theme"
	git clone https://github.com/addy-dclxvi/openbox-theme-collections
	echo -e "$okegreen ** Moving theme to ~/.themes/"
	mv openbox-theme-collections/* ~/.themes/
	rm -rf openbox-theme-collections
	echo -e ""
}

gtk_theme(){
	echo -e ""
	echo -e "$okegreen ** Downloading theme"
	git clone https://github.com/addy-dclxvi/gtk-theme-collections
	echo -e "$okegreen ** Moving theme to ~/.themes/"
	mv gtk-theme-collections/* ~/.themes/
	rm -rf gtk-theme-collections
	echo -e ""
}

tint2_theme(){
	echo -e ""
	echo -e "$okegreen ** Downloading theme"
	git clone https://github.com/addy-dclxvi/tint2-theme-collections
	echo -e "$okegreen ** Moving theme to ~/.config/tint2/"
	mv tint2-theme-collections/* ~/.config/tint2/
	rm -rf tint2-theme-collections
	echo -e ""
}

icon_menu(){
	echo -e ""
	echo -e "$red 1)$white MacOS iconpack"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		macos_icon
	fi
}

macos_icon(){
	echo -e ""
	echo -e "$okegreen ** Downloading icon"
	git clone https://github.com/keeferrourke/la-capitaine-icon-theme
	echo -e "$okegreen ** Moving theme to ~/.icons/"
	mv la-capitaine-icon-theme ~/.icons/
	echo -e ""
}

set_wallpaper(){
	echo -e ""
	echo -e "$red // Paste image you want to set as wallpaper"
	read -p " ?? image : " image;
	feh --bg-fill $image
	echo -e ""
}

fix_menu(){
	echo -e ""
	echo -e "$red 1)$white Enable tap-to-click"
	echo -e ""
	read -p " ?? select : " act;
	if [[ $act == 1 ]]
	then
		tap_to_click
	fi
}

tap_to_click(){
	echo -e ""
	echo -e "$okegreen ** Enabling tap-to-click"
	cp fix/tap-to-click /etc/X11/xorg.conf.d/30-touchpad.conf
	echo -e ""
}

banner
