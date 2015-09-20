#!/bin/bash
BareFileCo="/home/koen/gitBareRepoEncrypted"
echo "Warning, this script must be run as root, or use the sudoers script"
echo "Warning, git repo must be in the top level directory of the main git central"
echo "Name of the repo"
read REPO_NAME

echo "Users, seperated by ; without spaces"
read USERS

groupadd group_$REPO_NAME

export IFS=";"

for user in $USERS; do
echo "$user"
  usermod -G group_$REPO_NAME $user;
done

mkdir -p $BareFileCo/$REPO_NAME

chgrp -R group_$REPO_NAME $BareFileCo/$REPO_NAME

chmod 770 $BareFileCo/$REPO_NAME

