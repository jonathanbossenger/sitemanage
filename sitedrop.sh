#!/bin/bash

# Bash script to set drop local site created by sitesetup script 
# See https://gist.github.com/jonathanbossenger/2dc5d5a00e20d63bd84844af89b1bbb4

SSL_CERTS_DIRECTORY=/home/jonathan/ssl-certs
SITES_DIRECTORY=/home/jonathan/development/websites

SITE_NAME=$1
SITE_CONFIG_PATH=/etc/apache2/sites-available/$SITE_NAME.conf
SSL_SITE_CONFIG_PATH=/etc/apache2/sites-enabled/$SITE_NAME-ssl.conf

echo "Deleteing websites directory"

rm -rf $SITES_DIRECTORY/"$SITE_NAME"

echo "Disabling virtual hosts..."

a2dissite "$SITE_NAME".conf
a2dissite "$SITE_NAME"-ssl.conf

echo "Deleting virtual hosts..."

rm -rf "$SITE_CONFIG_PATH"
rm -rf "$SSL_SITE_CONFIG_PATH"

echo "Remove hosts record.."

sed -i "/$SITE_NAME.test/d" /etc/hosts

echo "Deleting database.."

mysql -uroot -ppassword --execute="DROP DATABASE $SITE_NAME;"

echo "Deleting certs.."

rm -rf $SSL_CERTS_DIRECTORY/"$SITE_NAME"*

echo "Restarting Apache..."

service apache2 restart

echo "Done"