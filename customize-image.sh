#!/bin/bash

# arguments: $RELEASE $FAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script
#
# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

RELEASE=$1
FAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4

# Set ARCH variable for choosing the right package architecture
ARCH=`dpkg --print-architecture`

case $RELEASE in
	wheezy)
	# your code here
	;;
	stretch)

	# Set of scripts to turn an ARMbian image into a full Ethereum node
	# Visit https://www.armbian.com for further info regarding image customization and Armbian itself
	# Diego Losada <diego.losadaf@gmail.com>

	# Manage hostname, ethereum account and SSD device on first boot
	cp /tmp/overlay/armbian_first_run.txt /boot
	cp -f /tmp/overlay/rc.local /etc
	cp -f /tmp/overlay/first_reboot.sh /usr/local/bin	
	cp -f /tmp/overlay/update-ethereum /usr/local/bin
        cp -f /tmp/overlay/install-trinity /usr/local/bin
	cp -f /tmp/overlay/cpufrequtils /etc/default
	# Install Ethereum client packages
	echo "Installing Parity and Geth Debian packages"	
	dpkg -i /tmp/overlay/geth_1.8.23-0_arm64.deb
        dpkg -i /tmp/overlay/parity_2.3.8-0_arm64.deb
	dpkg -i /tmp/overlay/ipfs_0.4.18-0_arm64.deb
        dpkg -i /tmp/overlay/status.im-node-0.23.8-0-beta8chaos_arm64.deb
	dpkg -i /tmp/overlay/raiden_0.100.2-0_arm64.deb

	;;
	trusty)
	# your code here
	;;
	xenial)
	# you can copy the above code here if you prefer Ubuntu instead of Debian
	;;
	bionic)
	# Manage hostname, ethereum account and SSD device on first boot
        cp /tmp/overlay/armbian_first_run.txt /boot
        cp -f /tmp/overlay/rc.local /etc
        cp -f /tmp/overlay/first_reboot.sh /usr/local/bin
	cp -f /tmp/overlay/update-ethereum /usr/local/bin
	cp -f /tmp/overlay/install-trinity /usr/local/bin
	cp -f /tmp/overlay/cpufrequtils /etc/default
        # Install Ethereum client packages
        echo "Installing Parity and Geth Debian packages"       
        dpkg -i /tmp/overlay/parity_2.3.8-0_arm64.deb
	dpkg -i /tmp/overlay/geth_1.8.23-0_arm64.deb
	dpkg -i /tmp/overlay/ipfs_0.4.18-0_arm64.deb
	dpkg -i /tmp/overlay/status.im-node-0.23.8-0-beta8chaos_arm64.deb
	dpkg -i /tmp/overlay/raiden_0.100.2-0_arm64.deb
	;;
esac
