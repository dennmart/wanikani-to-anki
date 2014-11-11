# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 9292, host: 9292
  config.vm.provision "shell", path: "https://gist.githubusercontent.com/dennmart/60788929cf89dde5d720/raw/41df26d6bf265021c329c86883d18f7e03b75b7f/provision.sh"
end
