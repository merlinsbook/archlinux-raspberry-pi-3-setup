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
echo "    version: 0.0.3"
echo "    BETA"
echo "  ___________________________________________________"
echo


#---------------------------------------------------
# List available devices?
read -p "   Show list of available disks before proceeding[Y/n]? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
 sudo fdisk -l
fi



#---------------------------------------------------
# Get SD device name
echo -e "${YELLOW}"
echo 
read -p "   Enter device name [sd(x)]: " SD



#---------------------------------------------------
# Get total of partitions on disk
echo -e "${GREEN}"
partitions=$(grep -c "${SD}[0-9]" /proc/partitions)
counter=1
echo
echo "  ___________________________________________________"
echo
echo "    ${partitions} partitions found"
echo
until [ $counter -gt $partitions ]
do
 echo "     - ${SD}${counter}"
 ((counter++))
done
echo
echo "  ___________________________________________________"
echo



#---------------------------------------------------
# Delete partitions?
if [ $partitions -gt 0 ]
then
echo -e "${RED}"
echo 
read -p "   In order to proceed with the installation the above partitions and contained data will have to be deleted completely. Do you wish to proceed[Y/n]?"  -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
 echo -e "${RED}"
 echo "Setup cancelled by user"
 exit
fi
fi
echo
read -p "   Are you absolutely sure you want to use '${SD}' to create your raspberry OS?[Y/n]"  -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
 echo -e "${RED}"
 echo "Setup cancelled by user"
 exit
fi



#---------------------------------------------------
# Unmount partitions...
echo -e "${GREEN}"
partitions=$(grep -c "${SD}[0-9]" /proc/partitions)
counter=1
until [ $counter -gt $partitions ]
do
 echo
 echo "     Unmounting ${SD}${counter} ..."
 sudo umount /dev/$SD$counter
 ((counter++))
done
echo
echo "All devices unmounted"

echo


#---------------------------------------------------
# Create workspace
workspace="temp_raspberry_pi_3_arch_linux_sd_creator_0.0.1"
sudo rm -rf $workspace
mkdir -p $workspace
cd $workspace



#---------------------------------------------------
# Install arch-linux?
echo -e "${GREEN}"
echo
read -p "   Start installation?[Y/n]"  -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
 echo -e "${RED}"
 echo
 echo "Setup cancelled by user"
 exit
fi



#---------------------------------------------------
# Delete old partitions
counter=1
until [ $counter -gt $partitions ]
do
 echo
 echo "     Deleting ${SD}${counter}"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk /dev/${SD}
  p
  d     
  ${counter}
  w
EOF
 ((counter++))
done



#---------------------------------------------------
# Create required partitions
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
EOF

#---------------------------------------------------
# Format partitions
# --> sdX1
sudo mkfs.vfat /dev/${SD}1 
sudo mkdir boot
sudo mount /dev/${SD}1 boot
# --> sdX2
sudo mkfs.ext4 -F /dev/${SD}2
sudo mkdir root
sudo mount /dev/${SD}2 root

#---------------------------------------------------
# Download and install arch-linux
echo -e "${GREEN}"
echo
echo "      Creating Arch-Raspberry SD..."
echo
sudo -u root wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
sudo -u root bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sudo -u root sync
sudo -u root mv root/boot/* boot
sudo -u root umount boot root

cd ..
sudo umount /dev/$SD'1'
sudo umount /dev/$SD'2'
sudo rm -rf $workspace

echo
echo "Arch-Linux was successfully installed onto /dev/${SD}"
echo