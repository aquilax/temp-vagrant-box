#!/usr/bin/env bash

apt-get update
apt-get -y install curl git build-essential vim-nox unzip
apt-get install -y apache2
apt-get install -y php5
apt-get install -y libapache2-mod-php5
apt-get install -y php5-mysqlnd php5-curl php5-xdebug php5-gd php5-intl php-pear php5-imap php5-mcrypt php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php-soap

php5enmod mcryp

# MySQL
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-5.5

a2enmod rewrite
service apache2 restart