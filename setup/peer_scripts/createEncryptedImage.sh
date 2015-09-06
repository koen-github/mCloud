#STEP TWO
#/bin/bash
echo "Note: you must be sudo user before running this script"
echo "Use this shell script to create an encrypted container for the Peer, please look into the code before you run this"

echo "Give full path to install location"
read INSTALL_LOCATION
echo "Size of Central image? e.g. 100M"
read IMAGE_SIZE
echo "Peer image name? "
read CE_NAME



cd $INSTALL_LOCATION

#create image of 100MB
echo "Creating image..."
dd if=/dev/zero of=$CE_NAME.img bs=1 count=0 seek=`$IMAGE_SIZE`


#generate random key file
echo "Generating random file..."
dd if=/dev/urandom of=$CE_NAME.keyfile bs=1024 count=1


#format encrypted
echo "Format encrypted image..."
sudo cryptsetup luksFormat $CE_NAME.img $CE_NAME.keyfile



#create mkfs4 partition
echo "Opening image..."
sudo cryptsetup luksOpen $CE_NAME.img $CE_NAME --key-file $CE_NAME.keyfile


echo "Creating mkfs4 partition..."
sudo mkfs.ext4 /dev/mapper/$CE_NAME

#mount to directory

echo "Creating install directory..."
mkdir $INSTALL_LOCATION/$CE_NAME

echo "Mounting encrypted mapper..."
sudo mount /dev/mapper/$CE_NAME $INSTALL_LOCATION/$CE_NAME


echo "Install completed, please use other shell scripts to start using mCloud"


