# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"
  config.vm.network "forwarded_port", guest: 80, host: 3002, protocol: 'tcp'
  config.vm.network "forwarded_port", guest: 5432, host: 54321, protocol: 'tcp'
  config.vm.define "somehost"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end  
  config.ssh.insert_key = false

  config.vm.provision "file",
  source: 'share/otrs.sql.gz',
  destination: "/tmp/otrs.sql.gz"

  config.vm.provision "file",
    source: 'share/Config/Config.pm',
    destination: "Config.pm"

  config.vm.provision "file",
    source: "config.pl.dist",
    destination: "/tmp/config.pl"    

  config.vm.provision "shell",
    path: "init.sh"

  config.vm.provision "shell",
    path: "db.sh"

  config.vm.provision "shell",
    path: "otrs.sh"
  
  config.vm.synced_folder "share/HTML/Templates/Standard/", "/opt/otrs/Kernel/Output/HTML/Templates/OPW/",
  owner: "otrs", group: "apache"

  #config.vm.synced_folder "C:\Users\shumakovk\projects\vagrant\otrs\share", "/home/vagrant/share"

end
