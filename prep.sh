# Declarations
NOCOLOR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'

#---------------------------------------------------
# Introduction
echo -e "${BLUE}"
echo
echo "  ___________________________________________________"
echo
echo "    R A S P B E R R Y  P I  3  -  A R C H L I N U X"
echo 
echo "                      SD Creator"
echo "    author: David Tolbert <npm.merlin.com>"
echo "    version: 0.0.1"
echo "    status: dev"
echo "  ___________________________________________________"
echo

# Workspace
mkdir temp_raspberry_pi_3_arch_linux_sd_creator_0.0.1
cd temp_raspberry_pi_3_arch_linux_sd_creator_0.0.1

#---------------------------------------------------
# List available devices?
read -p "Show list available disks before proceeding[Y/n]? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
 sudo fdisk -l
fi


#---------------------------------------------------
# Get SD device name
echo -e "${YELLOW}"
echo 
read -p "Enter device name [sd(x)]: " SD
read -p "Proceed to prepare ${SD}sda for raspberry arch linux installation? " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
 echo -e "${RED}"
 echo "Setup cancelled by user"
 exit
fi

#sudo dd if=/dev/zero of=/dev/${SD} bs=512 count=1
#---------------------------------------------------
# Create partitions
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk /dev/${SD}
  o     # clear partition table
  n     # create new partition
  p     # set as primary partition
  1     # set partition number to 1
        # default - start at beginning of disk 
  +100M # 100 MB boot partion
  t     # format partition
  c     # Fat32 (LBA)
  n     # new partition
  p     # primary partition
  2     # partion number 2
        # default, start immediately after preceding partition
        # default, extend partition to end of disk
  w     # write the partition table
  q     # quit
EOF


#---------------------------------------------------
# Format partitions and mount directories
# --> sdX1
sudo mkfs.vfat /dev/${SD}1
mkdir boot
sudo mount /dev/${SD}1 boot
# --> sdX2
sudo mkfs.ext4 /dev/${SD}2
mkdir root
sudo mount /dev/${SD}2 root


#---------------------------------------------------
# Download arch-linux and move it onto the SD card
sudo su
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync
mv root/boot/* boot
umount boot root

#---------------------------------------------------
# Delete temp folder?
read -p "Would you like to keep the temporary files(default=n)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
 cd ..
 rm -rf temp_raspberry_pi_3_arch_linux_sd_creator_0.0.1
 exit
fi

exit

## END OF SETUP