#!/bin/bash

site_download_wp(){
  if [ "$1" = '' ]; then
      echo 'Please specify a site to download WordPress'
      exit
  fi
  cd development/websites/"$1"/ || exit
  wp core download
}

wp_config_create() {
  wp config create --dbname=$1 --dbuser=root --dbpass=password
}

wp_core_install() {
  wp core install --url=$1 --title="$2" --admin_user=admin --admin_password=password --admin_email=jonathanbossenger@gmail.com
}
