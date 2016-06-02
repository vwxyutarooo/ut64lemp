#!/usr/bin/env bash

# root
sudo su


## Add nginx latest stable to apt
nginx=stable
add-apt-repository ppa:nginx/$nginx
## Git
apt-add-repository ppa:git-core/ppa
## PHP
add-apt-repository ppa:ondrej/php


# Purge
sudo apt-get purge php5
sudo apt-get purge apache2


# apt update
apt-get -y update
apt-get -y upgrade
apt-get -y autoremove


# Update and begin installing some utility tools
apt-get install -y python-software-properties
apt-get install -y vim git curl
apt-get install -y memcached build-essential
# Install nginx
apt-get install -y nginx
# Install PHP7
apt-get install php7.0 php7.0-fpm php7.0-mysql php7.0-xml -y


if ! [ -L /var/www ]; then
  # Symlink our host www to the guest /var/www folder
  rm -rf /var/www
  ln -fs /vagrant/www /var/www

  echo "Provisioning has completed. Default server should now be listening on http://192.168.33.10"
fi
