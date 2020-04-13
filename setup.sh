#!/bin/bash

# Bash script to set up local site using LAMP on Ubuntu
# TODO replace directories and MySQL credentials with variables from ~/.sitemanage config

#todo make sure we are runing as root
FILE="/tmp/out.$$"
GREP="/bin/grep"
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]
then
   echo "This script must be run as root" 1>&2
   exit 1
fi

SITE_NAME=$1
SITE_CONFIG_PATH=/etc/apache2/sites-available/$SITE_NAME.conf
SSL_SITE_CONFIG_PATH=/etc/apache2/sites-available/$SITE_NAME-ssl.conf

echo "Creating websites directory"

mkdir /home/jonathan/development/websites/$SITE_NAME
chown -R jonathan:jonathan /home/jonathan/development/websites/$SITE_NAME

echo "Setting up virtual hosts..."

cd /etc/apache2/sites-available/

VIRTUAL_HOST="<VirtualHost *:80>
        ServerName $SITE_NAME.test
        ServerAdmin webmaster@$SITE_NAME.test
        DocumentRoot /home/jonathan/development/websites/$SITE_NAME
        <Directory \"/home/jonathan/development/websites/$SITE_NAME\">
            #Require local
            Order allow,deny
            Allow from all
            AllowOverride all
            # New directive needed in Apache 2.4.3:
            Require all granted
        </Directory>
        ErrorLog \${APACHE_LOG_DIR}/$SITE_NAME-error.log
        CustomLog \${APACHE_LOG_DIR}/$SITE_NAME-access.log combined
</VirtualHost>"

echo "$VIRTUAL_HOST" | sudo tee -a $SITE_CONFIG_PATH

SSL_VIRTUAL_HOST="<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerName $SITE_NAME.test
        ServerAdmin webmaster@$SITE_NAME.test
        DocumentRoot /home/jonathan/development/websites/$SITE_NAME
        <Directory \"/home/jonathan/development/websites/$SITE_NAME\">
            #Require local
            Order allow,deny
            Allow from all
            AllowOverride all
            # New directive needed in Apache 2.4.3:
            Require all granted
        </Directory>
        ErrorLog \${APACHE_LOG_DIR}/$SITE_NAME-error.log
        CustomLog \${APACHE_LOG_DIR}/$SITE_NAME-access.log combined
        SSLEngine on
        SSLCertificateFile  /home/jonathan/ssl-certs/$SITE_NAME.test.pem
        SSLCertificateKeyFile /home/jonathan/ssl-certs/$SITE_NAME.test-key.pem
        <FilesMatch \"\.(cgi|shtml|phtml|php)\$\">
                SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>

    </VirtualHost>
</IfModule>"

echo "$SSL_VIRTUAL_HOST" | sudo tee -a $SSL_SITE_CONFIG_PATH

echo "Enabling virtual hosts..."

a2ensite $SITE_NAME.conf
a2ensite $SITE_NAME-ssl.conf

echo "Add hosts record.."

echo "127.0.0.1    $SITE_NAME.test" >> /etc/hosts

echo "Creating database.."

mysql -uroot -ppassword --execute="CREATE DATABASE $SITE_NAME;"

echo "Add certs.."

cd /home/jonathan/ssl-certs/
runuser -l jonathan -c "cd /home/jonathan/ssl-certs && mkcert $SITE_NAME.test"

echo "Restarting Apache..."

service apache2 restart

echo "Done."