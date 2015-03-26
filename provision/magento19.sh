#!/usr/bin/env bash

# Mostly from https://github.com/r-baker/simple-magento-vagrant

SITE_NAME="magento19"
MAGE_DIR_NAME=${SITE_NAME}
DB_NAME=${MAGE_DIR_NAME}
MAGE_DIR="/var/www/html/sites/${MAGE_DIR_NAME}"
MAGE_VERSION="1.9.1.0"
DATA_VERSION="1.9.0.0"


mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'magentouser'@'localhost' IDENTIFIED BY 'password'"
mysql -u root -e "FLUSH PRIVILEGES"


# apache
cp /vagrant/assets/000-${SITE_NAME}.conf /etc/apache2/sites-available/
a2ensite 000-${SITE_NAME}
service apache2 reload

# Download and extract
if [[ ! -f "${MAGE_DIR}/index.php" ]]; then
	mkdir -p ${MAGE_DIR}
	cd /tmp
	echo "Downloading..."
	wget -nv http://www.magentocommerce.com/downloads/assets/${MAGE_VERSION}/magento-${MAGE_VERSION}.tar.gz
	tar -zxvf magento-${MAGE_VERSION}.tar.gz
	mv magento/* magento/.htaccess ${MAGE_DIR}/
	cd ${MAGE_DIR}/
	chmod -R 777 media var
	chmod 777 app/etc

	# sample data - this is huge
	# cd /tmp
	# if [[ ! -f "/vagrant/magento-sample-data-${DATA_VERSION}.tar.gz" ]]; then
	# 	# Only download sample data if we need to
	#	echo "Downloading..."
	# 	wget -nv http://www.magentocommerce.com/downloads/assets/${DATA_VERSION}/magento-sample-data-${DATA_VERSION}.tar.gz
	# fi
	# tar -zxvf magento-sample-data-${DATA_VERSION}.tar.gz
	# cp -R magento-sample-data-${DATA_VERSION}/media/* ${MAGE_DIR}/media/
	# cp -R magento-sample-data-${DATA_VERSION}/skin/*  ${MAGE_DIR}/skin/
	# mysql -u root ${DB_NAME} < magento-sample-data-${DATA_VERSION}/magento_sample_data_for_${DATA_VERSION}.sql
fi

# Run installer
if [ ! -f "${MAGE_DIR}/app/etc/local.xml" ]; then
  cd ${MAGE_DIR}
  sudo /usr/bin/php -f install.php -- --license_agreement_accepted yes \
  --locale en_US --timezone "Europe/Stockholm" --default_currency SEK \
  --db_host localhost --db_name ${DB_NAME} --db_user magentouser --db_pass password \
  --url "http://${SITE_NAME}.local:8090/" --use_rewrites yes \
  --use_secure no --secure_base_url "http://${SITE_NAME}.local:8090/" --use_secure_admin no \
  --skip_url_validation yes \
  --admin_lastname Owner --admin_firstname Store --admin_email "admin@example.com" \
  --admin_username admin --admin_password password123123
  /usr/bin/php -f shell/indexer.php reindexall
fi

# Install n98-magerun
# --------------------
cd /tmp
echo "Downloading..."
wget -nv https://raw.github.com/netz98/n98-magerun/master/n98-magerun.phar
chmod +x ./n98-magerun.phar
sudo mv ./n98-magerun.phar /usr/local/bin/
