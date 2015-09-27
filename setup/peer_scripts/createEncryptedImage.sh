#STEP TWO
#/bin/bash
echo "Note: you must be sudo user before running this script"
echo "Use this shell script to create an encrypted container for the Peer, please look into the code before you run this"

echo "Give full path to install location"
read INSTALL_LOCATION
echo "Size of Central image? e.g. 100M"
read IMAGE_SIZE
echo "Peer image name? "
read PE_NAME



cd $INSTALL_LOCATION

#create image of 100MB
echo "Creating image..."
dd if=/dev/zero of=$PE_NAME.img bs=1 count=0 seek=$IMAGE_SIZE


#generate random key file
echo "Generating random file..."
dd if=/dev/urandom of=$PE_NAME.keyfile bs=1024 count=1


#format encrypted
echo "Format encrypted image..."
sudo cryptsetup luksFormat $PE_NAME.img $PE_NAME.keyfile



#create mkfs4 partition
echo "Opening image..."
sudo cryptsetup luksOpen $PE_NAME.img $PE_NAME --key-file $PE_NAME.keyfile


echo "Creating mkfs4 partition..."
sudo mkfs.ext4 /dev/mapper/$PE_NAME

#mount to directory

echo "Creating install directory..."
mkdir $INSTALL_LOCATION/$PE_NAME

echo "Mounting encrypted mapper..."
sudo mount /dev/mapper/$PE_NAME $INSTALL_LOCATION/$PE_NAME

sudo mkdir $INSTALL_LOCATION/$PE_NAME/CENTRAL_SERVER


echo "Install completed, please use other shell scripts to start using mCloud"


