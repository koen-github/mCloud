#/bin/bash
FILE_CONTENTS=`cat ~/LOCAL_CONFIG`
eval $FILE_CONTENTS
echo "Umounting mountpoint: $LOCATION_MOUNTPOINT"
sudo umount $LOCATION_MOUNTPOINT
sudo cryptsetup luksClose $LOCAL_FILE_CONTAINER 
##sudo umount /dev/mapper/$LOCAL_FILE_CONTAINER
