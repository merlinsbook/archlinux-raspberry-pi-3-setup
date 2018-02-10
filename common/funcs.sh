
indent() { sed 's/^/  /'; }
folder() { fold -s -w90; }
bold=$(tput bold)
normal=$(tput sgr0)
partitions=0
SD=''

header() 
{

  umountPartitions

  echo "${bold}${Blue}"
  echo
  echo "  ___________________________________________________"
  echo
  echo "    R A S P B E R R Y  P I  3  -  A R C H L I N U X"
  echo 
  echo "                      SD Creator"
  echo "    author: David Tolbert <npm.merlin@gmail.com>"
  echo "    version: 0.0.4"
  echo "    BETA"
  echo "  ___________________________________________________"
  echo
}


yesCancel() 
{ 
  showText=$1
  echo -n "$bold$showText [Y/n]: " | indent
  read showText
  if [[ $showText =~ ^[Nn]$ ]]
  then
    echo $Red
    echo "Setup cancelled by user" | indent
    echo
    echo
    exit
  fi
}

info()
{
  showText=$1
  echo $NC
  echo -n "$bold$showText" | folder | indent
  echo
  echo
}


listDisks()
{
  echo
  echo $bold$Blue"Available devices:" | indent
  echo
  lsblk -f | folder | indent
  echo
}

setSD()
{
  echo $bold$Red
  echo "The list above shows all available disks found on your system. Make sure to choose the correct device name" | folder | indent
  echo $bold$White
  read -p "  Enter device name [sd(x)]: " SDisk
  SD=$SDisk
  echo $bold$Red
  echo "Arch-Linux will be written to target device '${SD}'" | indent
  echo
}

getPartitions()
{
  SD=sdb
  partitions=$(grep -c "${SD}[0-9]" /proc/partitions) 
  echo $partitions
  echo $SD
}

umountPartitions()
{
  counter=1
  
  # Umount partitions
  if [ $partitions -gt 0 ]
  then
    until [ $counter -gt $partitions ]
    do
      if grep -qs '/dev/'$SD$counter /proc/mounts; then
        # Mounted
        echo #"mounted"
        sudo umount /dev/$SD$counter
      else
        # Not mounted
        echo #"not mounted"
      fi
      ((counter++))
    done

    if mountpoint -q "$SD" ; then
      # Mounted
      sudo umount /dev/$SD
    else
      # Not mounted
      echo
    fi
  fi
}

installOS()
{
  # Get number of partitions
  partitions=$(grep -c "${SD}[0-9]" /proc/partitions) 
  
  umountPartitions

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

   # Create workspace
  workspace="temp_raspberry_pi_3_arch_linux_sd_creator_0.0.1"
  sudo rm -rf $workspace
  mkdir -p $workspace
  cd $workspace

  # Format partitions
  # --> sdX1
  sudo mkfs.vfat /dev/${SD}1 
  sudo mkdir boot
  sudo mount /dev/${SD}1 boot
  # --> sdX2
  sudo mkfs.ext4 -F /dev/${SD}2
  sudo mkdir root
  sudo mount /dev/${SD}2 root

 

  # Download and install arch-linux
  echo -e "${bold}${Yellow}" | indent
  echo
  echo $bold$Blue"Creating rasparch SD..." | indent
  echo
  sudo -u root wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz  | indent
  echo
  echo -e "${bold}${Green}Arch-Linux downloaded. Unpacking to SD '${SD}'" | indent
  echo
  sudo -u root bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
  sudo -u root sync
  sudo -u root mv root/boot/* boot
  sudo -u root umount boot root

  umountPartitions

  cd ..
  sudo rm -rf $workspace

  echo "${bold}${Green}Done" | indent
  echo
  echo
}
