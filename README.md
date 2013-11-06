ssh-backup
==========

An ssh subsystem for backups

This is a simple solution for centralised backups, with the help of OpenSSH and standard UNIX tools, designed to be installed on the hosts being backed-up. The single requirement is that the hosts run OpenSSH, which is used for certificate-based authentication and connection encryption. The subsystem itself is a simple shellscript, configurable via files in /etc/ETS-backup/, currently using `tar(1)` for backup collection, but easily modifiable for `dump(8)` or any other tool you prefer.

A sample `installer` script is provided for OpenBSD systems. Please generate your ssh keys that will be used for backups and adapt the script before running. This installer creates a separate user `etsbackup` with `sudo(8)` privileges and installs an ssh public key in `~etsbackup/.ssh/authorized_keys`. The subsystem is installed in `/usr/local/sbin/backup-subsystem.sh` and the following is added to `/etc/ssh/sshd_config` to configure sshd to always force the subsystem on user `etsbackup`:

```
Subsystem backup /usr/local/sbin/backup-subsystem.sh
Match user backup 
   ForceCommand /usr/local/sbin/backup-subsystem.sh
   AllowTcpForwarding no
```

After installing the subsystem on your hosts, simply create a user `etsbackup` on your central backup server, add the private ssh key to `~etsbackup/.ssh/id_rsa`, and configure the server to receive backups on-demand using jobs like the following:

```
#!/bin/ksh
# daily backup script
#set -x
BKDIR=/mnt/backups/Network
DATE=$(date "+%Y/%m/%d")
HOSTS=/etc/ETS-backup/hosts.daily.list

if [ -s "${HOSTS}" ]
  then
  HOSTCNT=$(grep -c '[^[:space:]]' < "${HOSTS}")
  if [ $HOSTCNT -ne 0 ]
    then
    mkdir -p "$BKDIR/$DATE"
    for _host in $(<${HOSTS});do
      echo "Backup $BKDIR/$DATE/${_host}"
      sudo -u etsbackup ssh -T ${_host} > "$BKDIR/$DATE/${_host}.tgz"
    done
  fi
fi
```

Add hostnames or IP addresses of hosts to `/etc/ETS-backup/hosts.daily.list` and configure this to run daily via `cron(8)` to obtain backups from those hosts.
