#!/bin/bash
##WRITTEN BY: KOEN VAN DER KRUK
##VERSION 1
##CENTRAL PEER SCRIPT
CONFIG_FILE_NAME="~/MCLOUD_CONFIG_SERVER"

addUser() {
	echo "TODO: Adding user to central peer."
}

removeUser() {
	echo "TODO: Removing user to central peer"
}

removeMCLOUD() {
	echo "TODO: Removing MCLOUD package"
}

#########################
# OPENING MCLOUD IMAGE  #
#########################
openEncryptedContainer() {
	"Opening and mounting the already created mCloud instance.."
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi

	eval $CONFIG_FILE_NAME
	echo "Opening the image file: $IMAGE_FILE..."
	sudo cryptsetup luksOpen $IMAGE_FILE $LOCAL_FILE_CONTAINER --key-file $KEY_FILE
	echo "Mounting encrypted container..."
	sudo mount /dev/mapper/$LOCAL_FILE_CONTAINER $LOCATION_MOUNTPOINT
	echo "Mountpoint is attached"
}


#########################
# CLOSING MCLOUD IMAGE  #
#########################
closeEncryptedContainer() {
	"Closing the already mounted mCloud image."
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi

	eval $CONFIG_FILE_NAME
	echo "Umounting mountpoint: $LOCATION_MOUNTPOINT"
	sudo umount $LOCATION_MOUNTPOINT
	echo "Closing encrypted luksvolume"
	sudo cryptsetup luksClose $LOCAL_FILE_CONTAINER 
	echo "Mountpoint is closed"
}

#########################
# INSTALL SCRIPT MCLOUD #
#########################
installMCLOUD() {
	echo "First installing packages: sudo apt-get install sshfs lvm2 cryptsetup openssh-server openssh-client nfs-kernel-server nfs-common..."
	sudo apt-get install sshfs lvm2 cryptsetup openssh-server openssh-client nfs-kernel-server nfs-common
	sudo modprobe dm-mod

	echo "Creating Mcloud config file..."
	touch $CONFIG_FILE_NAME
	sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig

	echo "Settings SSHD config parameters..."
	sudo sh -c "echo \"PermitRootLogin 		no\" >> /etc/ssh/sshd_config"
	sudo sh -c "echo \"PasswordAuthentication 	no\" >> /etc/ssh/sshd_config"
	sudo sh -c "echo \"UsePAM			yes\" >> /etc/ssh/sshd_config" 

	LOCAL_IP=`hostname -I | cut -f1 -d' '`
	echo "Use this shell script to setup the central peer, please look into the code before you run this"
	echo "Give full path to install location? e.g. /home/koen/MCLOUD_TEST"
	read INSTALL_LOCATION
	echo "Size of Central image? e.g. 100M"
	read IMAGE_SIZE
	echo "Central Peer image name? e.g. CENTRAL_MCLOUD"
	read CE_NAME
	echo "Would you like to set this server up as VPN server? (y/n) first_time? == y"
	read OPEN_VPN
	echo "Would you like to setup this server with the ACL permissions system? (y/n) n=assuming you already setupped the harddrive as ACL"
	read ACL_SERVER

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
	


	if [ $OPEN_VPN == "y" ]
	then
		echo "Installing OpenVPN..."
		sudo ./central_peer_scripts/openvpn-install.sh
		echo "If you want to add clients later, run this command in this directory: sudo ./openvpn-install.sh And then select add Client."
	fi


	if [ $ACL_SERVER == "y" ]
	then
		sudo apt-get install acl
		echo "Please follow the rest of these steps online, I can't write a script that will handle all the special cases: https://help.ubuntu.com/community/FilePermissionsACLs#Enabling_ACLs_in_the_Filesystem
		"
		echo "Please run the following commands after finishing these steps: "
		echo "sudo setfacl -m g:users:rwx $INSTALL_LOCATION/$CE_NAME"
		echo "sudo setfacl -m other:--- $INSTALL_LOCATION/$CE_NAME"
		echo "sudo mkdir $INSTALL_LOCATION/$CE_NAME/home_directories"
	else
	
		echo "Appliying ACL rights."
		sudo setfacl -m g:users:rwx $INSTALL_LOCATION/$CE_NAME
		sudo setfacl -m other:--- $INSTALL_LOCATION/$CE_NAME
		sudo mkdir $INSTALL_LOCATION/$CE_NAME/home_directories
	fi

	echo "Saving MCLOUD_CONFIG_SERVER file.."

	echo "
	LOCATION_MOUNTPOINT=\"$INSTALL_LOCATION/$CE_NAME\"
	LOCAL_FILE_CONTAINER=\"$CE_NAME\"
	IMAGE_FILE=\"$INSTALL_LOCATION/$CE_NAME.img\"
	KEY_FILE=\"$INSTALL_LOCATION/$CE_NAME.keyfile\"
	HOME_DIRECTORY=\"$INSTALL_LOCATION/$CE_NAME/home_directories\"
	" > $CONFIG_FILE_NAME
	
	echo "Installation of MCLOUD is finished"

}

#########################
# The command line help #
#########################
display_help() {
    echo "This will run a few scripts for mCloud and this script will also ask some information before installing every component"
    echo ""
    echo "Usage: $0 [option...] {addUser | removeUser | removeMCLOUD | installMCLOUD| openEncryptedContainer | closeEncryptedContainer}" >&2
    echo ""
    echo "   -c, --configuration           Path to configuration file"
    echo "   -h, --help                    Display this help message"
    echo ""
    exit 1
}

################################
# Check if parameters options  #
# are given on the commandline #
################################
while :
do
    case "$1" in
      -c | --configuration)
 	  echo "Adding config file"
	  shift 2
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      --) # End of all options
          shift 2
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1 
          ;;
      *)  # No more options
          break
          ;;
    esac
done

###################### 
# Check if parameter #
# is set too execute #
######################
case "$1" in
  addUser)
    addUser
    ;;
  removeUser)
    removeUser
    ;;
  removeMCLOUD)
    removeMCLOUD	
    ;;
  installMCLOUD)
    installMCLOUD
    ;;
  openEncryptedContainer)
    openEncryptedContainer
    ;;
  closeEncryptedContainer)
    openEncryptedContainer
    ;;
  *)
	

     display_help
     exit 1
    ;;
esac

echo "Finishing"
