#!/bin/bash
FILE_CONTENTS=`cat ~/LOCAL_CONFIG`
eval $FILE_CONTENTS
echo $CENTRAL_IP
sudo sshfs -o allow_other $USER@$CENTRAL_IP:../../ $LOCATION_SSHFS_MOUNTPOINT -o IdentityFile=$USER_RSA_FILE  -p 22 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no




