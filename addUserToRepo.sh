#!/bin/bash
GIT_BARE_CENTRAL="/home/koen/gitBareRepoEncrypted"

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

sudo chgrp -R group_$REPO_NAME $GIT_BARE_CENTRAL/$REPO_NAME

sudo chmod g+w $GIT_BARE_CENTRAL/$REPO_NAME

