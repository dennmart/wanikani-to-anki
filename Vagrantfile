# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 9292, host: 9292

  # Provisioning is done by default via the shell.
  config.vm.provision "shell", path: "provisioning/provision.sh"

  # If you prefer to use Ansible for provisioning, you should comment the shell
  # provisioning line and uncomment the following lines.
  #config.vm.provision "ansible" do |ansible|
  #  ansible.playbook = "provisioning/playbook.yml"
  #end
end
