#!/bin/sh

usage() {
	echo "Usage: backup.sh [-honu] [-h] [-u user] [-n host name or ip] [-o output]"
}

while getopts "ho:n:u:" arg; do
	case $arg in
		h)
			usage
			exit
			;;
		n)
			UNIT_HOSTNAME=$OPTARG
			;;
		o)
			OUTPUT=$OPTARG
			;;
		u)
			UNIT_USERNAME=$OPTARG
			;;
		*)
			usage
			exit 1
	esac
done

# name of the ethernet gadget interface on the host
UNIT_HOSTNAME=${UNIT_HOSTNAME:-127.0.0.1}
# output backup tgz file
OUTPUT=${OUTPUT:-${UNIT_HOSTNAME}-backup-$(date +%s).tgz}
# username to use for ssh
UNIT_USERNAME=${UNIT_USERNAME:-pwnagotchi}
# what to backup
FILES_TO_BACKUP="/root/brain.nn \
  /root/brain.json \
  /root/.api-report.json \
  /root/.ssh \
  /root/.bashrc \
  /root/.profile \
  /root/handshakes \
  /root/peers \
  /etc/pwnagotchi/ \
  /etc/ssh/ \
  /etc/network/interfaces.d \
  /etc/wpa_supplicant/wpa_supplicant.conf \
  /var/log/syslog \
  /var/log/auth.log \
  /etc/network/interfaces \
  /var/log/pwnagotchi.log \
  /var/log/pwnagotchi*.gz \
  /home/$UNIT_USERNAME/.ssh \
  /home/$UNIT_USERNAME/.bashrc \
  /home/$UNIT_USERNAME/.profile \
  /home/$UNIT_USERNAME/.bash_profile \
  /root/.api-report.json \
  /root/.auto-update \
  /root/.bt-tether* \
  /root/.net_pos_saved \
  /root/.ohc_uploads \
  /root/.wigle_uploads \
  /root/.wpa_sec_uploads \
  /boot/config.txt \
  /boot/cmdline.txt"

ping -c 1 "${UNIT_HOSTNAME}" > /dev/null 2>&1 || {
  echo "@ unit ${UNIT_HOSTNAME} can't be reached, make sure it's connected and a static IP assigned to the USB interface."
  exit 1
}

echo "@ backing up $UNIT_HOSTNAME to $OUTPUT ..."
ssh "${UNIT_USERNAME}@${UNIT_HOSTNAME}" "sudo find ${FILES_TO_BACKUP} -type f -print0 | xargs -0 sudo tar cv" | gzip -9 > "$OUTPUT"
