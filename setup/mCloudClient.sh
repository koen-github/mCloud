#!/bin/bash
##WRITTEN BY: KOEN VAN DER KRUK
##VERSION 1
##CLIENT PEER SCRIPT
LOCATION_OF_SCRIPT=`readlink -f "$0"`

##aliases in bashrc
OPEN_CONTAINER="alias mcloud-opencontainer='$LOCATION_OF_SCRIPT openEncryptedContainer'"
CLOSE_CONTAINER="alias mcloud-closecontainer='$LOCATION_OF_SCRIPT closeEncryptedContainer'"
CONNECT_TO_CENTRAL="alias mcloud-connectclient='$LOCATION_OF_SCRIPT connectClientServer'"
DISCON_TO_CENTRAL="alias mcloud-disconclient='$LOCATION_OF_SCRIPT disconnectClientServer'"
ASSIGN_CLIENT="alias mcloud-assignserver='$LOCATION_OF_SCRIPT assignServer'"
ASSIGN_USER_TOREPO="alias mcloud-assignuser='$LOCATION_OF_SCRIPT assignUser'"
MCLOUD_ITSELF="alias mcloud='$LOCATION_OF_SCRIPT'"


USER=`whoami`
CONFIG_FILE_NAME="~/MCLOUD_CONFIG_CLIENT"

assignUser() {
	echo "Todo: assigning user to github repo on central server"
}

disconnectClientServer() {
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi
	eval $CONFIG_FILE_NAME
	echo "Disconnecting OpenVPN connection"
	sudo killall openvpn
	
	echo "Unmounting SSH mountpoint and tunnel"
	sudo umount $LOCATION_SSHFS_MOUNTPOINT
}

connectClientServer() {
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi
	eval $CONFIG_FILE_NAME
	echo "Opening client config file... "
	openvpn --config $OPENVPN_CONFIG

	echo "OPENVPN is connected"

	echo "Calling mCloud server and creating tunnel"

	ssh -fNv -L 3049:localhost:2049 $USER@$CENTRAL_IP -o IdentityFile=$USER_RSA_FILE ##THIS IS WRONG, TODO change central peer into openvpn
	sudo mount -t nfs -o port=3049 localhost:../../ $LOCATION_SSHFS_MOUNTPOINT 
	echo "Finished connecting to mCLoud server"

}

assignServer() {
	echo "Assigning this client to a mCloud server"
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi

	eval $CONFIG_FILE_NAME

	if [ -z "$USER_RSA_FILE" ]; then 
		echo "What is the IP-address of the mCloud server you want to connect to? (e.g. 94.123.43.8)"
		read IP_ADDRESS

		echo "Generating ssh key"
		ssh-keygen -t rsa

		echo "Now email the public ssh key to the central server"
		echo "Getting contents of ssh key... ~/.ssh/id_rsa.pub"
		echo "YOUR SSH KEY: "
		cat ~/.ssh/id_rsa.pub
		echo "You will receive an ovpn file from the mCloud server, place that one in your home directory. Rename it to: mcloudServer.ovpn"
		echo "OPENVPN_CONFIG=\"~/mcloudServer.ovpn\"" >> $CONFIG_FILE_NAME
		echo "USER=\"$USER\"" >> $CONFIG_FILE_NAME
		echo "USER_RSA_FILE=\"/home/$USER/.ssh/id_rsa\"" >> $CONFIG_FILE_NAME
		echo "CENTRAL_IP=\"$IP_ADDRESS\"" >> $CONFIG_FILE_NAME
	else
		echo "You already generated an rsa file, please contact mCloud server for the IP-address and the OpenVPN config file"
		exit 1
	fi
	

}

removeMCLOUD() {
	echo "TODO: Removing MCLOUD package"
}

#########################
# OPENING MCLOUD IMAGE  #
#########################
openEncryptedContainer() {
	
	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi

	echo "Opening and mounting the already created mCloud instance.."

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

	if [ ! -f $CONFIG_FILE_NAME ]; then
	    echo "ERROR: MCLOUD_CONFIG_SERVER file does not exists, please run setup first."
	    exit 1;
	fi

	echo "Closing the already mounted mCloud image."

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
	sudo apt-get install nfs-common portmap sshfs lvm2 cryptsetup openvpn
	sudo modprobe dm-mod

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

	echo "
	LOCATION_MOUNTPOINT=\"$INSTALL_LOCATION/$PE_NAME\"
	LOCATION_SSHFS_MOUNTPOINT=\"$INSTALL_LOCATION/$PE_NAME/CENTRAL_SERVER\"
	LOCAL_FILE_CONTAINER=\"$PE_NAME\"
	IMAGE_FILE=\"$INSTALL_LOCATION/$PE_NAME.img\"
	KEY_FILE=\"$INSTALL_LOCATION/$PE_NAME.keyfile\"
	HOME_DIRECTORY=\"$INSTALL_LOCATION/$PE_NAME/home_directories\"
	" > $CONFIG_FILE_NAME

	echo "Adding easy commands to BASHRC as aliases..."
	echo $OPEN_CONTAINER >> ~/.bashrc
	echo $CLOSE_CONTAINER >> ~/.bashrc
	echo $CONNECT_TO_CENTRAL >> ~/.bashrc
	echo $ASSIGN_CLIENT >> ~/.bashrc
	echo $DISCON_TO_CENTRAL >> ~/.bashrc
	echo $MCLOUD_ITSELF >> ~/.bashrc
	echo $ASSIGN_USER_TOREPO >>  ~/.bashrc
	
	echo "Reloading BASHRC Contents..."
	. ~/.bashrc


	echo "Install completed, please connect this client to the central server."
	echo "Now run this script anytime you like to connect to a central mCLoud server using: mcloud-assignserver"


}

#########################
# The command line help #
#########################
display_help() {
    echo "Warning: RUN THIS SCRIPT ONLY ON A PEER FOR MCLOUD"
    echo "This will run a few scripts for mCloud and this script will also ask some information before installing every component"
    echo ""
    echo "Usage: $0 [option...] { installMCLOUD | removeMCLOUD | connectClientServer | disconnectClientServer | assignServer | openEncryptedContainer | closeEncryptedContainer | assignUser }" >&2
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
  removeMCLOUD)
    removeMCLOUD	
    ;;
  installMCLOUD)
    installMCLOUD ##added
    ;;
  assignServer)
    assignServer
    ;;
  assignUser)
    assignUser
    ;;
  connectClientServer)
    connectClientServer 
    ;;
  disconnectClientServer)
    disconnectClientServer
    ;;
  openEncryptedContainer)
    openEncryptedContainer ##added
    ;;
  closeEncryptedContainer)
    openEncryptedContainer  ##added
    ;;
  *)
	

     display_help
     exit 1
    ;;
esac

echo "Finishing"
