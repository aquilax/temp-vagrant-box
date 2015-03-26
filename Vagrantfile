# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "dev-modules"

  config.vm.network "forwarded_port", guest: 80, host: 8090

  config.ssh.forward_agent = true

  config.vm.synced_folder "project", "/var/www/html", owner: "www-data", group: "www-data"

  config.vm.provision :shell, path: "./provision/bootstrap_root.sh"
  config.vm.provision :shell, path: "./provision/prestashop16.sh"
  config.vm.provision :shell, path: "./provision/magento19.sh"
end
