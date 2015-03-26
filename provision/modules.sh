#!/usr/bin/env bash

PROJECT_ROOT="/var/www/html"
MODULES_ROOT="${PROJECT_ROOT}/modules";

ssh-keyscan -H github.com >> ~/.ssh/known_hosts

mkdir -p ${MODULES_ROOT}
cd ${MODULES_ROOT}

git clone git@github.com:fyndiq/fyndiq-prestashop-module.git
pushd fyndiq-prestashop-module
git submodule update --init --recursive
popd
ln -s ${MODULES_ROOT}/fyndiq-prestashop-module "${PROJECT_ROOT}/sites/prestashop16/modules/fyndiq"

git clone git@github.com:fyndiq/fyndiq-magento-module.git
pushd fyndiq-magento-module
git submodule update --init --recursive
bash fyndman.sh build "${PROJECT_ROOT}/sites/magento19/"