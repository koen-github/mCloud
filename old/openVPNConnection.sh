#!/bin/bash
FILE_CONTENTS=`cat ~/LOCAL_CONFIG`

echo "Installing OPENVPN..." 
sudo apt-get install openvpn

echo "Opening client config file... "
openvpn --config OPENVPN_CONFIG

echo "OPENVPN is connected"

