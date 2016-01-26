#!/bin/bash
FILE_CONTENTS=`cat ~/LOCAL_CONFIG`
eval $FILE_CONTENTS
echo $CENTRAL_IP

ssh -fNv -L 3049:localhost:2049 $USER@$CENTRAL_IP -o IdentityFile=$USER_RSA_FILE
sudo mount -t nfs -o port=3049 localhost:../../ $LOCATION_SSHFS_MOUNTPOINT 

##sudo sshfs -o allow_other $USER@$CENTRAL_IP:../../ $LOCATION_SSHFS_MOUNTPOINT -o IdentityFile=$USER_RSA_FILE  -p 22 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no OLD




