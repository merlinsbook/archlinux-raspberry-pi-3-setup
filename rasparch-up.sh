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
echo "          A R C H L I N U X  -  S E T U P"
echo 
echo "    author: David Tolbert <npm.merlin.com>"
echo "    version: 0.0.2"
echo "    BETA"
echo "  ___________________________________________________"
echo


#---------------------------------------------------
# Keyboard layout
echo -e "${YELLOW}" 
read -p "   Enter a keymap to set your keyboard layout[default=en]: " keymap
localectl set-keymap --no-convert $keymap


#---------------------------------------------------
# Installations
#pacman -S openssh --noconfirm
#pacman -S postgresql --noconfirm
pacman -Syu --noconfirm
pacman -S docker --noconfirm
pacman -S docker-compose --noconfirm
pacman -S nodejs --noconfirm
systemctl enable docker.service
systemctl start docker
echo
echo -e "${GREEN}" 
echo "System update complete"
echo -e "${NOCOLOR}" 