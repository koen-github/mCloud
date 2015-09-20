#!/bin/bash
##Change paths and names to your own needs
##use this when you are logged in, in the account you want connect to the central peer
IP="192.168.178.10"
USER=`whoami`
LOCATION_MOUNTPOINT="/home/koen/fileCo1/remoteGit"

sudo sshfs -o allow_other $USER@$IP:../../ $LOCATION_MOUNTPOINT -o IdentityFile=/home/$USER/.ssh/id_rsa




