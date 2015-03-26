#!/usr/bin/env bash

# Mostly from https://github.com/nurelm/prestashop_vagrant


PS_VERSION=prestashop_1.6.0.14.zip
SITE_NAME="prestashop16"
PS_NAME=${SITE_NAME}
LOCK=/var/www/html/${SITE_NAME}
DB_NAME=${PS_NAME}
PS_DIR="/var/www/html/sites/${PS_NAME}"


if [[ -f ${LOCK} ]]; then
	exit
fi

mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'magentouser'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -e "FLUSH PRIVILEGES"

# apache
cp /vagrant/assets/000-${PS_NAME}.conf /etc/apache2/sites-available/
a2ensite 000-${PS_NAME}
service apache2 reload

# download prestashop
mkdir -p ${PS_DIR}
cd /tmp
echo "Downloading..."
wget -nv http://www.prestashop.com/download/old/${PS_VERSION}
unzip -o ${PS_VERSION}
cp -r prestashop/* ${PS_DIR}
rm -rf prestashop

# install http://doc.prestashop.com/display/PS16/Installing+PrestaShop+using+the+command-line+script
cd ${PS_DIR}/install
php index_cli.php --domain=${PS_NAME}.local:8090 --db_server=localhost --db_name=${DB_NAME} --db_user=root
rm -rf ${PS_DIR}/install
mv ${PS_DIR}/admin ${PS_DIR}/admin1234

touch ${LOCK}