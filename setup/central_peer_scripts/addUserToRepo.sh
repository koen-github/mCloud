#!/bin/bash
BareFileCo="/home/koen/gitBareRepoEncrypted"

echo "Warning, git repo must be in the top level directory of the main git central"
echo "Name of the repo"
read REPO_NAME

echo "Users, seperated by ; without spaces"
read USERS

sudo groupadd group_$REPO_NAME

export IFS=";"

for user in $USERS; do
echo "$user"
  sudo usermod -G group_$REPO_NAME $user;
done

mkdir -p $BareFileCo/$REPO_NAME

sudo chgrp -R group_$REPO_NAME $BareFileCo/$REPO_NAME

sudo chmod 770 $BareFileCo/$REPO_NAME

