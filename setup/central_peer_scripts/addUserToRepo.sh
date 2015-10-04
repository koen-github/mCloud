#!/bin/bash
BareFileCo="/home/koen/gitBareRepoEncrypted"
echo "Use this script as ./addUserToRepo.sh REPO_NAME LIST_OF_USERS_SEPERATED_BY;"
echo "Or open and follow steps"
echo "Warning, this script must be run as root, or use the sudoers script"
echo "Warning, git repo must be in the top level directory of the main git central"
if [ -z $1 ]
then

echo "Name of the repo"
read REPO_NAME

else
REPO_NAME=$1
fi

if [ -z $2 ]
then
echo "Users, seperated by ; without spaces"
read USERS
else
USERS=$2
fi



groupadd group_$REPO_NAME

export IFS=";"

for user in $USERS; do
echo "$user"
  usermod -G group_$REPO_NAME $user;
done

mkdir -p $BareFileCo/$REPO_NAME

chgrp -R group_$REPO_NAME $BareFileCo/$REPO_NAME

chmod 770 $BareFileCo/$REPO_NAME

