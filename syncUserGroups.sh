#!/bin/bash
##Todo get user and groups from central server
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
