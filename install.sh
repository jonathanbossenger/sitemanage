#!/bin/bash

# Bash script to install sitemanage
# Requires Debian/Ubuntu, Apache2, MySQL, PHP, and mkcert (https://github.com/FiloSottile/mkcert)

# shellcheck disable=SC2006
DIST=`lsb_release -si`
if [ "$DIST" == 'Ubuntu' ] || [ "$DIST" == 'Debian' ]
then
  echo "Installing sitemanage scripts..."
else
    echo "Not running on Ubuntu or Debian. Exiting."
    exit
fi

if ! command -v apache2 >/dev/null
then
    echo "Apache2 is not installed, please install Apache2 web server. Exiting."
    exit
fi

if ! command -v mysql >/dev/null
then
    echo "MySQL Server is not installed, please install MySQL Server. Exiting."
    exit
fi

if ! command -v php >/dev/null
then
    echo "PHP is not installed, please install PHP. Exiting."
    exit
fi

MKCERT=`runuser -l jonathan -c "command -v mkcert"`
if [ "$MKCERT" == "" ]
then
    echo "mkcert is not installed, please install mkcert. Exiting."
    exit
fi

echo "What is your MySQL username?"
read MYSQL_USERNAME

echo "What is your MySQL password?"
read MYSQL_PASSWORD

echo "What is the full path to sites directory?"
read SITES_PATH

echo "What is the full path to the directory where you want to store your mkcert SSL certificates?"
read SSL_CERTS_PATH

echo "Writing variables to config file..."

CONFIG="MYSQL_USERNAME=$MYSQL_USERNAME
MYSQL_PASSWORD=$MYSQL_PASSWORD
SITES_PATH=$SITES_PATH
SSL_CERTS_PATH=$SSL_CERTS_PATH"

echo "$CONFIG" | sudo tee -a /home/$USER/.sitemanage

#todo copy setup and drop scripts to /usr/local/bin/
#todo chmod +x these scripts

echo "Done!"

