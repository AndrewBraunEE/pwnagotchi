BACKUP_FILE="127.0.0.1-backup-1703029168.tgz"
sudo ./restore.sh -b $BACKUP_FILE;
sudo ifconfig wlan0 down && sudo ifconfig mon0 down && sudo iwconfig mon0 mode Managed && sudo iwconfig wlan0 mode Managed && sudo service network-manager restart && sudo ifconfig wlan0 up && sudo ifconfig mon0 up
