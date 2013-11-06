ssh-backup
==========

An ssh subsystem for backups

This is a simple solution for centralised backups, with the help of OpenSSH (for certificate-based authentication and encryption) and standard UNIX tools (the script uses `tar(1)`, but it is easily modifiable for `dump(8)` or `rsync(1)`). The subsystem is designed to be installed on the hosts being backed-up. The advantage of a subsystem

