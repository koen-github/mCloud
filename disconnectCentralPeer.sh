#!/bin/bash
FILE_CONTENTS=`cat LOCAL_CONFIG`
eval $FILE_CONTENTS

sudo umount $LOCATION_SSHFS_MOUNTPOINT
