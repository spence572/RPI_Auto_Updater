# Created On:	13/05/2017
# Created By:	Paul Spencer based on http://www.instructables.com/id/Raspberry-Pi-Auto-Update/ by JaredT22
# Description:	File to configure the auto update for the RPI.


cd ~
sudo mkdir updater
sudo mkdir updater/logs
touch updater/logs/cronlog
chmod -R 777 updater
cd updater

#Create the update.sh script
sudo touch update.sh

echo "#!/bin/sh" >> update.sh
echo "sudo apt-get update && sudo apt-get upgrade -y" >> update.sh
echo "sudo rpi-update" >> update.sh
echo "sudo apt-get autoremove" >> update.sh
echo "sudo apt-get autoclean" >> update.sh
echo "sudo reboot" >> update.sh

sudo chmod +x update.sh

(crontab -l 2>/dev/null; echo "0 0 * * SAT /home/pi/updater/update.sh 2>/home/pi/updater/logs/cronlog") | crontab -