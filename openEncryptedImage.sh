#!/bin/bash
##Change paths and names to your own needs.
LOCAL_FILE_CONTAINER="fileCo2"
IMAGE_FILE="encrypted.img"
KEY_FILE="mykey.keyfile"

sudo cryptsetup luksOpen $IMAGE_FILE $LOCAL_FILE_CONTAINER --key-file $KEY_FILE

sudo mount /dev/mapper/$LOCAL_FILE_CONTAINER ~/$LOCAL_FILE_CONTAINER

