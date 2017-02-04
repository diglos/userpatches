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
ARCH=`dpkg --print-architecture`

case $RELEASE in
	wheezy)
	# your code here
	;;
	jessie)

	# Minor Ethereum tweaks
	# Diego Losada <diego.losadaf@gmail.com>
	
	# Assign hostname on first boot
	cp /tmp/overlay/armbian_first_run.txt /boot
	
	# Create pi user and assign groups for Geth and Parity systemd daemon
	echo "Creating pi user for Geth and Parity"
	if ! id -u pi >/dev/null 2>&1; then
		adduser --disabled-password --gecos "" pi
	fi
	echo "pi:ethereum" | chpasswd
	for GRP in sudo netdev audio video dialout plugdev bluetooth; do
  		adduser pi $GRP
	done	
	
	# Disable new account creation
	rm -rf /root/.not_logged_in_yet

	# Install Geth and Parity Debian packages
	# check ARCH and choose the right architecture (armhf or arm64)
	echo "Installing Parity and Geth Debian packages"
	if [[ $ARCH == armhf ]]; then
		dpkg -i /tmp/overlay/libssl1.1_1.1.0c-2_armhf.deb
        	dpkg -i /tmp/overlay/parity-rasp_1.5.0-1_armhf.deb
		dpkg -i /tmp/overlay/geth-rasp_1.5.8-0_armhf.deb
	else
		dpkg -i /tmp/libssl1.1_1.1.0c-2_arm64.deb
                dpkg -i /tmp/overlay/parity-rasp_1.5.0-1_arm64.deb
		dpkg -i /tmp/overlay/geth-rasp_1.5.8-0_arm64.deb
	fi
	;;
	trusty)
	# your code here
	;;
	xenial)
	# your code here
	;;
esac
