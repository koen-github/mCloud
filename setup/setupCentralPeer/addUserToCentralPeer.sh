#!/bin/bash

echo "Add user to central peer using SSH-KEY PAIR"
echo "Please make sure you changed the ssh config file to only allow ssh-key pair login"

echo "Specify public key file location of user"
read PUB_FILE

echo "Specify central peer ssh directory"
read SSH_LOCATION

CONTENTS_OF_KEY=`cat $PUB_FILE`
echo "\n\n" >> $SSH_LOCATION/authorized_keys
echo $CONTENTS_OF_KEY >> $SSH_LOCATION/authorized_keys
