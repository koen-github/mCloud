#!/bin/bash
FILE_CONTENTS=`cat LOCAL_CONFIG`
eval $FILE_CONTENTS
echo $IMAGE_FILE

sudo cryptsetup luksOpen $IMAGE_FILE $LOCAL_FILE_CONTAINER --key-file $KEY_FILE

sudo mount /dev/mapper/$LOCAL_FILE_CONTAINER $LOCATION_MOUNTPOINT

