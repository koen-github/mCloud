#!/bin/bash
##WRITTEN BY: KOEN VAN DER KRUK
##VERSION 1
##CENTRAL PEER SCRIPT

addUser() {
	echo "Adding user to central peer."
}

removeUser() {
	echo "Removing user to central peer"
}

removeMCLOUD() {
	echo "Removing MCLOUD package"
}

installMCLOUD() {
	echo "Installing MCLOUD"
}

#########################
# The command line help #
#########################
display_help() {
    echo "This will run a few scripts for mCloud and this script will also ask some information before installing every component"
    echo ""
    echo "Usage: $0 [option...] {addUser|removeUser|removeMCLOUD|installMCLOUD}" >&2
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
  *)
     display_help
     exit 1
    ;;
esac

echo "Finishing"
