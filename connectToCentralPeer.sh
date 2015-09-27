#!/bin/bash
FILE_CONTENTS=`cat LOCAL_CONFIG`
eval $FILE_CONTENTS
echo "IP $IP"
sudo sshfs -o allow_other $USER@$CENTRAL_IP:../../ $LOCATION_MOUNTPOINT -o IdentityFile=$USER_RSA_FILE 




