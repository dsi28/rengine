#!/bin/bash

tput setaf 2;
cat web/art/1.0.txt

tput setaf 3; echo "Before running this script, please make sure you have made changes to .env file."
tput setaf 1; echo "Changing the postgres username & password from .env is highly recommended."

tput setaf 4;
read -p "Are you sure, you made changes to .env file (y/n)? " answer
case ${answer:0:1} in
    y|Y|yes|YES|Yes )
      echo "Continiuing Installation!"
    ;;
    * )
      nano .env
    ;;
esac

echo " "
tput setaf 3;
echo "#########################################################################"
echo "Please note that, this installation script is only intended for Linux"
echo "For Mac and Windows, refer to the official guide https://rengine.wiki"
echo "#########################################################################"

echo " "
tput setaf 4;
echo "Installing reNgine and it's dependencies"

echo " "
if [ "$EUID" -ne 0 ]
  then
  tput setaf 1; echo "Error installing reNgine, Please run this script as root!"
  tput setaf 1; echo "Example: sudo ./install.sh"
  exit
fi

echo " "
tput setaf 4;
echo "#########################################################################"
echo "Installing Docker..."
echo "#########################################################################"
if [ -x "$(command -v docker)" ]; then
  tput setaf 2; echo "Docker already installed, skipping."
else
  curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
  tput setaf 2; echo "Docker installed!!!"
fi


echo " "
tput setaf 4;
echo "#########################################################################"
echo "Installing docker-compose"
echo "#########################################################################"
if [ -x "$(command -v docker-compose)" ]; then
  tput setaf 2; echo "docker-compose already installed, skipping."
else
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  tput setaf 2; echo "docker-compose installed!!!"
fi


echo " "
tput setaf 4;
echo "#########################################################################"
echo "Installing make"
echo "#########################################################################"
if [ -x "$(command -v make)" ]; then
  tput setaf 2; echo "make already installed, skipping."
else
  apt install make
fi


echo " "
tput setaf 4;
echo "#########################################################################"
echo "Installing reNgine"
echo "#########################################################################"
make certs && make build && make up

tput setaf 2; echo "reNgine is installed!!!"

sleep 3

echo " "
tput setaf 4;
echo "#########################################################################"
echo "Creating an account"
echo "#########################################################################"
make username

tput setaf 2; echo "Thank you for installing reNgine, happy recon!!"