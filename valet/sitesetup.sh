#!/bin/bash

# Bash script to set up local site using Laravel Valet on macOS on Ubuntu
# Requires Laravel Valet (https://github.com/FiloSottile/mkcert)
# See also sitedrop.sh https://gist.github.com/jonathanbossenger/4950e107b0004a8ee82aae8b123cce58

HOME_USER=jonathan
SITES_DIRECTORY=/Users/jonathan/development/websites

SITE_NAME=$1

MYSQL_DATABASE=$(echo $SITE_NAME | sed 's/[^a-zA-Z0-9]//g')

echo "Creating websites directory"

mkdir $SITES_DIRECTORY/"$SITE_NAME"
## chown -R $HOME_USER:$HOME_USER $SITES_DIRECTORY/"$SITE_NAME"

echo "Parking Laravel site..."

cd $SITES_DIRECTORY/"$SITE_NAME"
valet link

echo "Creating database.."

mysql -uroot -ppassword --execute="CREATE DATABASE $MYSQL_DATABASE;"

echo "Securing Laravel site.."

valet secure $SITE_NAME

echo "Done."