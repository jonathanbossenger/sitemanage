#!/bin/bash

# shellcheck disable=SC2006
APACHE=`command -v apache2`
echo "$APACHE"

if [ "$APACHE" == "" ]
then
    echo "APACHE is not installed, please install APACHE web server. Exiting."
    exit
fi

NGINX=`command -v nginx`
echo "$NGINX"

if [ "$NGINX" == "" ]
then
    echo "Nginx is not installed, please install Nginx web server. Exiting."
    exit
fi

#. ~/.sitemanage
#echo $MYSQL_USERNAME
#echo $MYSQL_PASSWORD
#echo $SITES_PATH
#echo $SSL_CERTS_PATH

exit