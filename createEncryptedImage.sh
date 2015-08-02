#/bin/bash
#create image of 100MB
dd if=/dev/zero of=`$USER`encryptedMCloud.img bs=1 count=0 seek=100M

#generate random key file

dd if=/dev/urandom of=`$USER`encryptedMCloud.keyfile bs=1024 count=1

#format encrypted

sudo cryptsetup luksFormat `$USER`encryptedMCloud.img `$USER`encryptedMCloud.keyfile

#create mkfs4 partition

sudo cryptsetup luksOpen `$USER`encryptedMCloud.img `$USER`encryptedMCloud --key-file `$USER`encryptedMCloud.keyfile

sudo mkfs.ext4 /dev/mapper/`$USER`encryptedMCloud

#mount to directory

mkdir ~/`$USER`encryptedMCloud

sudo mount /dev/mapper/`$USER`encryptedMCloud ~/`$USER`encryptedMCloud

