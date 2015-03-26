#!/usr/bin/env bash

# Mostly from https://github.com/nurelm/prestashop_vagrant

## Change this to the PS version you'd like to use
PS_VERSION=prestashop_1.6.0.14.zip
PS_NAME="prestashop16"
DB_NAME=${PS_NAME}
PS_DIR="/vagrant/project/sites/${PS_NAME}"

mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'magentouser'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -e "FLUSH PRIVILEGES"

# apache
cp /vagrant/assets/000-${PS_NAME}.conf /etc/apache2/sites-available/
a2ensite 000-${PS_NAME}
service apache2 reload

# download prestashop
mkdir -p ${PS_DIR}
ln -fs ${PS_DIR} /var/www/html/${PS_NAME}
cd /tmp
wget -nv http://www.prestashop.com/download/old/${PS_VERSION}
unzip -o ${PS_VERSION}
mv prestashop/* ${PS_DIR}

# install http://doc.prestashop.com/display/PS16/Installing+PrestaShop+using+the+command-line+script
cd ${PS_DIR}/install
php index_cli.php --domain=${PS_NAME}.local --db_server=localhost --db_name=${DB_NAME} --db_user=root
rm ${PS_DIR}/install
mv ${PS_DIR}/admin ${PS_DIR}/admin1234
