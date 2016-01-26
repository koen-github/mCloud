Before you can use the script located in this directory, please run setup on both the Central or Local peers.
Copy the file LOCAL_CONFIG to your home directory, and then change the information

Only change the LOCAL_CONFIG script parameters.

Do not change the filename of LOCAL_CONFIG.

When receiving the message:
sudo: sshfs: command not found

please run:

sudo apt-get install sshfs

AND:

sudo apt-get install lvm2 cryptsetup
sudo modprobe dm-mod

=====
If the central sever has support for VPN connection, please run as client the OPENVPN connection script.
