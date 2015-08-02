#!/bin/bash

sudo cryptsetup luksOpen encrypted.img fileCo2 --key-file mykey.keyfile

sudo mount /dev/mapper/fileCo2 ~/fileCo2

