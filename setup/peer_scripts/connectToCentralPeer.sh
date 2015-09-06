#!/bin/bash
USER=`whoami`
IP=$1
sudo sshfs -o allow_other $USER@$IP:/home/koen/gitBareRepoEncrypted /home/$USER/fileCo1/remoteGit -o IdentityFile=/home/$USER/.ssh/id_rsa
