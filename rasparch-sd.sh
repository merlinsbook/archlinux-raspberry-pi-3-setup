# Declarations
installpath=./common

# Includes
. $installpath/colors.sh
. $installpath/funcs.sh

#logFile="$HOME/Library/Logs/${scriptBasename}.log"

clear

header

info "This script will create a bootable SD for the Raspberry-Pi device."

yesCancel "Proceed to setup?"

listDisks

setSD

yesCancel "Are you sure you want to continue the installation?"

installOS