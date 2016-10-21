#!/usr/bin/env bash


sudo su

# Base configulation
## locale
sed -e "s/^AcceptEnv LANG LC\_\*/#AcceptEnv LANG LC\_\*/" /etc/ssh/sshd_config
export LANG=en_US.UTF-8
export LC_ALL=$LANG
locale-gen --purge $LANG
dpkg-reconfigure -f noninteractive locales && /usr/sbin/update-locale LANG=$LANG LC_ALL=$LANG

## timezone
echo Asia/Tokyo > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata


# Add nginx latest stable to apt
nginx=stable
add-apt-repository ppa:nginx/$nginx
## Git
apt-add-repository ppa:git-core/ppa
## PHP
add-apt-repository ppa:ondrej/php
## MySQL
add-apt-repository ppa:ondrej/mysql-5.7


# apt update
apt-get -y update
apt-get -y upgrade
apt-get -y autoremove


# Begin installing some utility tools
apt-get install -y python-software-properties
apt-get install -y vim git curl
apt-get install -y memcached build-essential

## locale
apt-get install -y language-pack-ja
cp /usr/share/locale/locale.alias $HOME/locale.alias
sed -E 's/(ja_JP[\t]+ja_JP\.)eucJP/\1UTF-8/g' -i $HOME/locale.alias
locale-gen --purge --aliases=$HOME/locale.alias 

## Install nginx
apt-get install -y nginx

## Install PHP
apt-get install php7.0 php7.0-fpm php7.0-mysql php7.0-xml php7.0-curl php7.0-mbstring -y
### Composer
php -r 'copy("https://getcomposer.org/installer", "composer-setup.php");'
php -r 'if (hash_file("SHA384", "composer-setup.php") === "e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae") { echo "Installer verified"; } else { echo "Installer corrupt"; unlink("composer-setup.php"); } echo PHP_EOL;'
php composer-setup.php
php -r 'unlink("composer-setup.php");'

## MySQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install mysql-server-5.7 -y

MYSQL_PWD=root mysql -u root -e "source /vagrant/tools/bootstrap.sql"


# Create symlinks
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/www /var/www
fi

if ! [ -L /etc/nginx ]; then
  /vagrant/tools/nginx.sh
fi

# Swap
/vagrant/tools/swap.sh


echo "Provisioning has completed. Default server should now be listening on http://192.168.33.10"
