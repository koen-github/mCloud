#!/bin/bash
echo "Have you changed the config_server file? (y/n)"
read CHANGED
if [[ "$CHANGED" == "n" ]]
then
exit 1
fi

echo "Add user to central peer using SSH-KEY PAIR"
echo "Please make sure you changed the ssh config file to only allow ssh-key pair login"

eval `cat config_server`

if [ -z "$HOME_DIRECTORY" ]; then 

echo "Specify the location to all the home directories of the user"
read HOME_LOCATION

else
HOME_LOCATION="$HOME_DIRECTORY"

fi

if [ -z "$USERPEER_PUB_FILE" ]; then 
echo "Specify public key file location of user"
read PUB_FILE

else
PUB_FILE="$USERPEER_PUB_FILE"

fi


echo "Make sure the public key file is generated by ssh-keygen"

CONTENTS_OF_KEY=`cat $PUB_FILE`

echo "This will be the username to login with"
USER_NAME=`ssh-keygen -l -f $PUB_FILE | cut -f4 -d' ' | cut -f1 -d'@'`
echo $USER_NAME
echo "Correct? (y/n)"
read COR
if [[ $COR == *"n"* ]]
then
echo "Specify another username: "
read USER_NAME
fi

USER_HOME=$HOME_LOCATION/$USER_NAME
echo "Home directory will be: $USER_HOME"

echo "Adding user to central peer"

sudo useradd -s /bin/bash -m -d $USER_HOME -c "PEER USER" -g users $USER_NAME

sudo mkdir -p $USER_HOME/.ssh
sudo sh -c "echo \" \" >> $USER_HOME/.ssh/authorized_keys"
echo "Copying pub key file to location..."

sudo sh -c "echo $CONTENTS_OF_KEY >> $USER_HOME/.ssh/authorized_keys"

echo "Applying rights"
sudo chown -R $USER_NAME $USER_HOME
sudo chmod 700 -R $USER_HOME

echo "Adding user to NFS share"
sudo sh -c "echo \"  $USER_HOME  localhost(insecure,rw,sync,no_subtree_check) \" >> /etc/exports "
echo "Exporting /etc/exports file"

sudo /etc/init.d/nfs-kernel-server start
sudo exportfs -a


echo "SSH server restarting"
/etc/init.d/ssh restart
