#!/bin/bash
##########
# HEADER
##########
# SCRIPT:		NAME_of_SCRIPT
# AUTHOR:		Paul Spencer based on
# http://www.instructables.com/id/Raspberry-Pi-Auto-Update/ by JaredT22
# DATE:			13/05/2017
# COPYRIGHT:	Copyright (c) Paul Spencer
# LICENCE:		MIT License
#
# PURPOSE: File to configure the auto update for the RPI.
#
##########
# HISTORY
##########
# Date			Author	Description
# 2017/05/13	PDS		Script creation
# 2017/05/16	PDS		Header added
# 2017/08/28	PDS		Added dist-upgrade
#
##########
# END_OF_HEADER
##########
#
#
##########
# USAGE
##########
#
USAGE="Looks like you have already ran this script. Please rm -r updater and the cron entry then rerun"

if [[ -d updater ]]
	then
	echo $USAGE
    exit 1
fi



##########
# SCRIPT
##########
cd ~
mkdir updater
mkdir updater/logs
touch updater/logs/cronlog
chmod -R 777 updater
cd updater

#Create the update.sh script
touch update.sh

echo "#!/bin/sh" >> update.sh
echo "sudo apt-get update && sudo apt-get upgrade -y" >> update.sh
echo "sudo apt-get -y dist-upgrade" >> update.sh
echo "sudo rpi-update" >> update.sh
echo "sudo apt-get autoremove" >> update.sh
echo "sudo apt-get autoclean" >> update.sh
echo "sudo reboot" >> update.sh

#Check if motioneye is installed, if so update the package
if [[ `ps -ef | grep motioneye | grep -v grep` ]]
then
    echo "pip install motioneye --upgrade" >> update.sh
    echo "systemctl restart motioneye" >> update.sh
fi
#
chmod +x update.sh

(crontab -l 2>/dev/null; echo "0 0 * * SAT /home/pi/updater/update.sh 2>/home/pi/updater/logs/cronlog") | crontab -
