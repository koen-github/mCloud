#!/bin/bash

echo "Add user to central peer using SSH-KEY PAIR"
echo "Please make sure you changed the ssh config file to only allow ssh-key pair login"

echo "Specify public key file location of user"
read PUB_FILE

echo "Specify central peer ssh directory"
read SSH_LOCATION

echo "Make sure the public key file is generated by ssh-keygen"

CONTENTS_OF_KEY=`cat $PUB_FILE`

echo "This will be the username to login with"
USER_NAME=`ssh-keygen -l -f $PUB_FILE | cut -f4 -d' ' | cut -f1 -d'@'`
echo $USER_NAME
echo "Correct? (y/n)"
read COR
if [[ $COR == *"n"* ]]
then
echo "Specify another username: "
read USER_NAME
fi

echo " " >> $SSH_LOCATION/authorized_keys
echo "Copying pub key file to location..."

echo $CONTENTS_OF_KEY >> $SSH_LOCATION/authorized_keys

echo "Adding user to central peer"

sudo useradd $USER_NAME

echo "SSH server restarting"
/etc/init.d/ssh restart
