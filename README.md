# Raspberry Pi Arch Linux Setup

The provided scripts automate the manual process of installing arch-linux onto a raspberry pi device and setting up a basic enviroment for developments. Make sure you're connected to the internet at all times.

> The provided scripts were intended for personal use only.

> Manual installation guide: https://archlinuxarm.org/platforms/armv6/raspberry-pi


## Creating a bootable SD (rasparch-sd.sh)

#### Test Enviroment

- Hardware Plattform: x86_64
- OS: Ubuntu Linux zw 4.13.0-32-generic

#### HowTo

To setup a bootable *arch-linux* SD insert your SD into your computer, open a terminal and follow the steps shown below. The script will handle the partitioning of the SD and installation of the OS.

**Make sure you know the exact name of the SD you wish to use as storage!**

```shell
>> git clone https://github.com/merlinsbook/archlinux-raspberry-pi-3-setup.git

>> cd archlinux-raspberry-pi-3-setup

>> chmod +rwx rasparch-sd.h

>> ./rasparch-sd.h

``` 

## Prepare your Raspberry OS for development (rasparch-up.sh)

#### Test Enviroment

- Hardware: Raspberry Pi 3
- OS: Arch-Linux

#### HowTo

This script updates your system and creates a basic development enviroment.
To get started insert your newly created OS SD into your *raspberry-pi* and fire it up. If everything goes well you will be asked to login. Sign in with **username=root** and **password=root** then follow the steps below.

```shell

>> pacman -S git --noconfirm

>> git clone https://github.com/merlinsbook/archlinux-raspberry-pi-3-setup.git

>> cd archlinux-raspberry-pi-3-setup

>> chmod +rwx rasparch-up.sh

>> ./rasparch-up.h
```

## Integration Test

```shell
>> cd archlinux-raspberry-pi-3-setup/docker

>> docker-compose up
``` 