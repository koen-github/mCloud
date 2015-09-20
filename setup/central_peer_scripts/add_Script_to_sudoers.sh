#!/bin/bash
echo "WARNING, THIS SCRIPT MUST BE RUN AS ROOT"
ADD_USER_TO_REPO_LOCATION="/home/koen/mCloud/setup/central_peer_scripts/addUserToRepo.sh"
echo "This script will add this line to the sudoers file: "
echo "%users ALL=NOPASSWD: $ADD_USER_TO_REPO_LOCATION"
echo "So normal 'users' can run the addUserToRepo script without being asked for a sudo password"


echo "%users ALL= (root) NOPASSWD: $ADD_USER_TO_REPO_LOCATION" | (EDITOR="tee -a" visudo)

