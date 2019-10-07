# Disclaimer

This is a custom configuration for creating an Ethereum full node based on the Armbian build tools. Please visit https://www.armbian.com and https://github.com/igorpecovnik/lib for further info regarding ARMBIAN.

Currently (as of July 2019) these scripts are developed to build an Armbian image for the FriendlyElec NanoPC-T4 [1] and PINE RockPRO64 [5] boards due to the high hardware specs needed to sync the Ethereum Blockchain. A NVMe M.2 SSD drive is needed as well.

If you are looking for an image for the Raspberry Pi 2/3/4, please visit:

https://github.com/diglos/pi-gen

For more information regarding Ethereum please visit:

- https://ethereum.org/
- https://www.reddit.com/r/ethereum/


# EthArmbian

EthArmbian (ARM64) [1] is a custom Ubuntu Linux image for the **NanoPC-T4 ARM SoC** [2]  and the **RockPro64 ARM SoC** [3] that runs Geth or Parity Ethereum clients as a boot service and **automatically turns the device into a full Ethereum node**. It includes other components of the Ethereum ecosystem such as **Trinity, Status.im, Raiden, IPFS, Swarm and Vipnode as well as initial support for Eth2.0 clients**.

Images take care of all process, from setting up the environment to running the Ethereum software and synchronizing the blockchain. All you need is to flash the MicroSD card with the image, plug an ethernet cable and power on the device.

These are the main EthArmbian features:

- Based on Armbian [2] **Ubuntu Bionic 18.04**
- Automatically **resizes the SD card**
- **Partitions and formats the NVMe SSD drive** (in case is detected) and mount it as /home for storing the Ethereum blockchain under the **ethereum user account**
- Adds some swap memory (4GB) to prevent memory issues (applies only if a NVMe drive is detected)
- **Changes the hostname to something like “ethnode-e2a3e6fe”** (HEX chunk based on the MAC hash)
- Limits cpu frequency to prevent database corruption issues due to high temperature (Only for NanoPC-T4)
- Automatically reboots once for hostname change and swap to take effect
- **Runs Geth [3] by default as a Systemd service** in Light Server mode and starts syncing the Blockchain
- **Watches the Ethereum client binary** and respawns it in case it gets killed
- **Includes Parity** [4] Ethereum client as well so you can switch both clients
- Includes other components of the Ethereum framework such as **Status.im, Raiden, IPFS and Swarm**.
- Includes an **APT repository** for upgrading packages
- Includes **automatic upgrades** through "Unattended upgrades" system
- Includes Fan control service on RockPro64 board

# Software installed (run sudo update-ethereum)

## Ethereum clients
- Geth 1.9.6
- Parity 2.5.9

## Ethereum framework
-  Swarm: 0.5.0
 - Raiden Network: 0.100.4
 - IPFS: 0.4.22
 - Status.im: 0.30.0~beta2
 - Vipnode: 2.2.1
 - Prysm Eth2.0 clients: 0.2.1

# What you need

1. A **Friendly Elec NanoPC-T4 ARM SoC** [1] or a **RockPro64 ARM SoC** [5]
2. Micro SD Card and SD Adaptor (for flashing the MicroSD)
3. NVMe M.2 SSD (minimum 256GB, 500GB recommended). **Keep in mind that without a NVMe M.2 SSD drive there’s absolutely no chance of syncing the blockchain.**
4. An ethernet cable
5. EthArmbian image, download link below (see build instructions if you don't own a NanoPC-T4)
6. (Optional) 30303 Port forwarding. This is a recommended setting (see below)
7. (Optional) USB keyboard, Monitor and HDMI cable


# EthArmbian Images

**Current Geth and Parity packages version**: 2019/10/07

Parity 2.5.9 and Geth 1.9.6

Run "update-ethereum" command to update to the latest versions. This is now an apt-get install alias

**Current image release date**: 2019/10/07

Parity 2.5.9 and Geth 1.9.6

There are 2 images available. One for the Nanopc-T4 ARM Soc, and one for RockPro64 with Geth as default client:

https://ethraspbian.com/downloads/Armbian_5.98_Nanopct4_Ubuntu_bionic_default_4.4.192.img.zip
https://ethraspbian.com/downloads/Armbian_5.98_Rockpro64_Ubuntu_bionic_default_4.4.192.img.zip

For other compatible devices please check below instructions for building the image by yourself.

# Install instructions

## In a nutshell

1. Flash the Armbian Image on your MicroSD Card (in your desktop or laptop computer, see below for detailed instructions)
2. Get the NanoPC-T4 or the RockPro64
3. Plug in the MicroSD card
4. Plug in the NVMe M.2 SSD drive
5. Plug in the Ethernet cable
6. Power on the board

You are all set. Take into account that the installer needs to perform some operations before it wakes up so you may need to wait about 1 minute (this includes 1 reboot).

For a full Ethereum node to be online the whole blockchain needs to be synced (to the very last block) so it will take some time to get there (see the FAQ section).

## Flashing the EthArmbian image

### MicroSD Install instructions for Linux

Insert the MicroSD in your SD adapter and plug it into your desktop or laptop computer. It is recommended to umount partitions in case  you have a preformated card.

Note: If you are not comfortable with command line, you can use Etcher:

https://etcher.io/

1. Open a terminal and check your MicroSD device name running:

`sudo fdisk -l`

You should see a device named `mmcblk0` or `sdd` (that matchs with the size of your card. This is a dangerous operation so be careful). For further info please visit:

https://www.raspberrypi.org/documentation/installation/installing-images/linux.md

2. Flash the MicroSD:

Installing Geth image:

```
unzip AArmbian_5.98_Nanopct4_Ubuntu_bionic_default_4.4.192.img.zip
sudo dd bs=1M if=Armbian_5.98_Nanopct4_Ubuntu_bionic_default_4.4.192.img of=/dev/mmcblk0 && sync
```

3. Extract the MicroSD card

You are done. Insert the MicroSD into your ARM SoC and power it on.

### Instructions for Windows

Please see:

https://www.raspberrypi.org/documentation/installation/installing-images/windows.md

### Instructions for Mac

Please see:

https://www.raspberrypi.org/documentation/installation/installing-images/mac.md

## Port forwarding

If you are going to run a full Ethereum node you may forward the 30303 port from your router to your device. This is an optional but recommended setting. There are 2 ways of doing this:

- Enable uPNP on your router. This automates the forwarding process (geth and parity take care of it), but it is less secure
- Forward the 30303 port to your NanoPC-T4 IP on your router. There are plenty of tutorials out there for doing this (it depends on your router model)

## Switching clients

Both clients (Geth and Parity) are included in the image so you can switch from one to another anytime. Let’s say you are running parity, by typing:

```
sudo systemctl stop parity && sudo systemctl disable parity
sudo systemctl enable geth && sudo systemctl start geth
```

these commands will disable parity and start the geth daemon.


## Managing the daemon

### Starting, stopping and getting the client status

Geth and Parity run as a bootup service so the client wakes up automatically. You can stop, start, restart and check the console output using systemctl:

`sudo systemctl stop|start|restart|status geth` or
`sudo systemctl stop|start|restart|status parity`

### Changing settings

Both clients settings are stored on /etc/ethereum/ directory (geth.conf file for geth and parity.conf file for parity), so you just have to edit these files and restart the daemon, for instance, changing cache value in geth:

# FAQ

These are some common asked questions:

## How do I connect to the board?

You can use SSH or a Monitor + USB keyboard. If you don't have a monitor connected you can discover the Nano IP by connecting to your router or using tools like nmap in order to connect though SSH.

## How can I log in?

```
User: ethereum 
Password: ethereum
```

**It is strongly recommended to change the default password by running:**

`passwd`

You can access as root as well:

```
User: root
Password: 1234 (you will be prompted to change the default password the first time you log in)
```

## How long does it take to sync the Ethereum blockchain? 

For Parity client, just a few hours (4-5). Geth takes 2 and a half days. (as of September 2018).

## Which is the blockchain size once synced?

For Parity, 180 GB. For Geth, about 160GB. (as of July 2019). Please note that there is currently an issue with Geth 1.9

## I'm seeing lots of "Database compacting, degraded performance" messages (geth)

You are fine. This is an expected behaviour in LevelDB databases. See:

https://github.com/ethereum/go-ethereum/issues/16871#issuecomment-395372313

## I'm seeing lots of "Imported new state entries" messages, is the node synced? (geth)

No, not yet. You will need to wait for the whole import process to finish (as of September 2018, about 218 million state entries). More info:

[Karalabe Geth syncing explanation](https://github.com/ethereum/go-ethereum/issues/16218#issuecomment-371454280)

## The snapshot synchronization is stuck (parity).

The most probably reason is that the snapshot is no longer available (it changes from time to time). Just stop parity, remove the data and restart the sync process by running:

```
sudo systemctl stop parity
sudo rm -rf /home/ethereum/.local/share/io.parity.ethereum/
sudo systemctl start parity
```

## Time is not accurate or the Time Zone is incorrect

Run the following command to sync time and change the Time Zone

`sudo armbian-config`

Go to "Personal" --> "Time zone" and choose the correct one.

## Is it possible to sync the blockchain with a SD card or a HDD drive?

Absolutely not. You will need an NVMe M.2 SSD Drive.

## Which client is better?

Both clients are great. If you want to keep the blockchain size as low as possible and sync ASAP, Parity is probably the best option. If you want to support light clients or test swarm, you may go for Geth.

## Where can I find more info about the blockchain synchronization?

These links are a good start:

- [Karalabe Geth syncing explanation](https://github.com/ethereum/go-ethereum/issues/16218#issuecomment-371454280)
- [Geth and Parity syncing explained by Afri Schoedon](https://dev.to/5chdn/the-ethereum-blockchain-size-will-not-exceed-1tb-anytime-soon-58a)

## Where can I see Geth or Parity logs?

By running one of these commands (depends on the client):
```
systemctl status geth
systemctl status parity
```
Also, by running:

`tail -f /var/log/syslog`

You can also monitor a tail of the log of any service running in the background like so:

```bash
sudo journalctl -u geth -f
```
## Can I buy a board with the image preinstalled?
Yes, see the links section. This is ran by Bruno Skvorc and the store is non-profit 

## Links

- [1] https://www.friendlyarm.com/index.php?route=product/product&product_id=225
- [2] https://www.armbian.com
- [3] https://github.com/ethereum/go-ethereum
- [4] https://github.com/paritytech/parity-ethereum
- [5] https://store.pine64.org/?product=rockpro64-4gb-single-board-computer
Components
https://store.pine64.org/?product=rockpro64-pci-e-x4-to-m-2ngff-nvme-ssd-interface-card
https://store.pine64.org/?product=rockpro64-10mm-low-profile-heatsink-with-fan

Get the NanoPC-T4 with all components assembled and the EthArmbian image preinstalled
https://blockandmortar.io

# Armbian image build instructions (for other devices)

If you don't own a Nanopc-T4 you can build an Armbian custom image for your board (in case is powerfull enough to sync the blockchain). Check here if your device is supported:

https://www.armbian.com/download/

## Prerequisites

- Ubuntu 18.04 (virtual or physical machine)
- Superuser rights
- Git

I strongly recommend the vagrant environment.

## Git branch and instructions

For building your own image, please check the Armbian documentation.

https://docs.armbian.com/

# Tip

If you want to support EthArmbian you can drop some Ether here :-)

`0x10BE809ad5F8Da1C675A26344E05cD9b56De6306`
