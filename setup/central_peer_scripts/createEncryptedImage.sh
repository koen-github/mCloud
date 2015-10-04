#/bin/bash
LOCAL_IP=`hostname -I | cut -f1 -d' '`
echo "Use this shell script to setup the central peer, please look into the code before you run this"
echo "Give full path to install location"
read INSTALL_LOCATION
echo "Size of Central image? e.g. 100M"
read IMAGE_SIZE
echo "Central Peer image name? "
read CE_NAME
echo "Would you also like to install openSSH? (y/n)"
read OPEN_SSH


cd $INSTALL_LOCATION

#create image of 100MB
echo "Creating image..."
dd if=/dev/zero of=$CE_NAME.img bs=1 count=0 seek=$IMAGE_SIZE


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

sudo chown -R root:users $INSTALL_LOCATION/$CE_NAME 
sudo chmod 775 $INSTALL_LOCATION/$CE_NAME #only chmod first directory

sudo mkdir $INSTALL_LOCATION/$CE_NAME/home_directories


if [ $OPEN_SSH == "y" ]
then
echo "Installing OpenSSH..."

sudo apt-get install openssh-server openssh-client

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
echo "Opening SSH config file"
sudo nano /etc/ssh/sshd_config
fi

echo "Install completed, please use other shell scripts to start using mCloud"
echo "Connect the peers using this command: (only local IP) "
echo "sudo sshfs -o allow_other USERPEER@$LOCAL_IP:$INSTALL_LOCATION/$CE_NAME USER_LOCATION"

echo "------------------------------------"
echo "Please enable in ssh config only ssh-key pair login, so it is not required for users to setup a password"
echo "SSH-config settings must look like this: "
echo "
PermitRootLogin 	no
PasswordAuthentication 	no
UsePAM			yes

"
