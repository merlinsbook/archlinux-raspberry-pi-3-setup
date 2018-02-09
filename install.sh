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
echo "    version: 0.0.1"
echo "    BETA"
echo "  ___________________________________________________"
echo


#---------------------------------------------------
# Set keyboard layout
echo -e "${YELLOW}" 
read -p "   Enter a keymap to set your keyboard layout[default=de]: " keymap
localectl set-keymap --no-convert $keymap


#---------------------------------------------------
# Update & upgrade system
pacman -Syu --noconfirm
pacman -S docker --noconfirm
pacman -S docker-compose --noconfirm