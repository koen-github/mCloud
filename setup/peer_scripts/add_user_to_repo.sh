#!/bin/bash
##Change paths and names to your own needs
##use this when you are logged in, in the account you want connect to the central peer
IP="192.168.178.10"
USER=`whoami`


echo "This script will run a remote script on the central peer server"
echo "Follow the steps when they are asked"
ssh $USER@$IP -o IdentityFile=/home/$USER/.ssh/id_rsa -p 22
sudo /home/koen/mCloud/setup/central_peer_scripts/addUserToRepo.sh 




