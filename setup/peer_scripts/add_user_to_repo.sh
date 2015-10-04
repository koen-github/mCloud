#!/bin/bash
##Change paths and names to your own needs
##use this when you are logged in, in the account you want connect to the central peer
LOCAL_CONFIG=`cat ~/LOCAL_CONFIG`
eval $LOCAL_CONFIG


echo "This script will run a remote script on the central peer server"
echo "Name of the repo"
read REPO_NAME

echo "Users, seperated by ; without spaces"
read USERS


ssh $USER@$IP -o IdentityFile=$USER_RSA_FILE -p 22 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo ../../addUserToRepo.sh $REPO_NAME $USERS" 




