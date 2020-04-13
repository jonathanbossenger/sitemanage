#!/bin/bash

# Bash script to drop local site created by sitesetup script
# TODO replace directories and MySQL credentials with variables from ~/.sitemanage config

SITE_NAME=$1
SITE_CONFIG_PATH=/etc/apache2/sites-available/$SITE_NAME.conf
SSL_SITE_CONFIG_PATH=/etc/apache2/sites-enabled/$SITE_NAME-ssl.conf

echo "Deleteing websites directory"

rm -rf /home/jonathan/development/websites/$SITE_NAME

echo "Disabling virtual hosts..."

a2dissite $SITE_NAME.conf
a2dissite $SITE_NAME-ssl.conf

echo "Deleting virtual hosts..."

rm -rf $SITE_CONFIG_PATH
rm -rf $SSL_SITE_CONFIG_PATH

echo "Remove hosts record.."

sed -i "/$SITE_NAME.test/d" /etc/hosts

echo "Deleting database.."

mysql -uroot -ppassword --execute="DROP DATABASE $SITE_NAME;"

echo "Deleting certs.."

rm -rf /home/jonathan/ssl-certs/$SITE_NAME*

echo "Restarting Apache..."

service apache2 restart

echo "Done"