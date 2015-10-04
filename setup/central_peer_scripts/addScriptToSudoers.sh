#!/bin/bash
LOCAL_CONFIG=`cat ~/LOCAL_CONFIG`
eval $LOCAL_CONFIG
echo "WARNING, THIS SCRIPT MUST BE RUN AS ROOT"
echo "Make sure the file ~/LOCAL_CONFIG exists"

ADD_USER_TO_REPO_LOCATION="`pwd`/addUserToRepo.sh"
echo "Copying addUserToRepo.sh to central server cloud"
cp $ADD_USER_TO_REPO_LOCATION $LOCATION_MOUNTPOINT
echo "This script will add this line to the sudoers file: "
echo "%users ALL=NOPASSWD: $LOCATION_MOUNTPOINT/addUserToRepo.sh"
echo "So normal 'users' can run the addUserToRepo script without being asked for a sudo password"


echo "%users ALL=NOPASSWD: $LOCATION_MOUNTPOINT/addUserToRepo.sh" | (EDITOR="tee -a" visudo)

