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
	;;
	xenial)
	;;
	bionic)
	# Manage NVMe drive, create ethereum account and change hostname on first boot
        cp /tmp/overlay/armbian_first_run.txt /boot
        cp -f /tmp/overlay/rc.local /etc
        cp -f /tmp/overlay/first_reboot.sh /usr/local/bin
	# Install Trinity client script
	cp -f /tmp/overlay/install-trinity /usr/local/bin
	# Limit cpu frequency to prevent CPU throttling (nanopc-t4 only)
	if [ "$BOARD" == "nanopct4" ];
	then
		cp -f /tmp/overlay/cpufrequtils /etc/default
	fi
	# Configure unattended upgrades
	cp -f /tmp/overlay/02-armbian-periodic /etc/apt/apt.conf.d/
	cp -f /tmp/overlay/20auto-upgrades /etc/apt/apt.conf.d/
	cp -f /tmp/overlay/50unattended-upgrades /etc/apt/apt.conf.d/
	# Override some systemd timer values
	install -Dv /dev/null /etc/systemd/system/apt-daily.timer.d/override.conf
	cat << EOF >> /etc/systemd/system/apt-daily.timer.d/override.conf
[Timer]
OnCalendar=00/4:00
RandomizedDelaySec=1m
EOF

	install -Dv /dev/null /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf
	cat << EOF >> /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf
[Timer]
OnCalendar=00/4:00
RandomizedDelaySec=5m
EOF
	# Add APT EthRaspbian repository
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8A584409D327B0A5
	add-apt-repository -n "deb http://apt.ethraspbian.com bionic main"
	add-apt-repository -n "deb http://apt.ethraspbian.com bionic-security main"
	add-apt-repository "deb http://apt.ethraspbian.com bionic-upgrades main"
	# Install Ethereum packages
	apt-get install geth
	apt-get install swarm parity ipfs raiden status.im-node vipnode prysm-beacon prysm-validator
	# Install ATS script for handling fan activiy and disable ZRAM on rockpro64 to avoid RAM issues
	if [ "$BOARD" == "rockpro64" ];
	then
        	apt-get install ats-rockpro64
		systemctl disable armbian-zram-config
	fi
	# Create alias for upgrading Ethereum packages
	cat <<EOF >> /etc/bash.bashrc
alias update-ethereum='
sudo apt-get update
sudo apt-get install geth swarm ipfs parity raiden status.im-node vipnode prysm-beacon prysm-validator'
EOF
	;;
esac
