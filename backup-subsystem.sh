#!/bin/ksh
# $Id$
# An attempt for a smarter backup subsystem.
#
# Add to your /etc/ssh/sshd_config
# Subsystem backup /usr/local/bin/backup-subsystem.sh
#
CONF=/etc/ETS-backup/backup.conf
BKLIST=/etc/ETS-backup/bklist
PRECMD=/etc/ETS-backup/precmd.conf
POSTCMD=/etc/ETS-backup/aftercmd.conf
DSTSTORE=/home/etsbackup/service_dumps
SUDO=/usr/bin/sudo
export CONF BKLIST PRECMD POSTCMD DSTSTORE SUDO
# FOR LINUX
#TAR="/bin/tar -zcpf - -T"
TAR="/bin/tar -zcpf - -I"

if [ -f ${CONF} ]; then
	. ${CONF}
fi

if [ -f ${PRECMD} ]; then
	. ${PRECMD} 2>/dev/null
fi

# backup our list.
${SUDO} $TAR ${BKLIST}

if [ -f ${POSTCMD} ]; then
	. ${POSTCMD} 2>/dev/null
fi
