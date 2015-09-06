#!/bin/bash

echo "Generating ssh key"
ssh-keygen -t rsa

echo "Now email the public ssh key to the central server"
echo "Getting contents of ssh key... ~/.ssh/id_rsa.pub"
echo "YOUR SSH KEY: "
cat ~/.ssh/id_rsa.pub






