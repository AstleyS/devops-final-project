# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # Backend VM configuration
  config.vm.define "backend" do |backend|
    backend.vm.box = "ubuntu/jammy64"
    backend.vm.hostname = "backend"

    # Private network for backend
    backend.vm.network "private_network", ip: "192.168.56.10" # Backend IP
    backend.vm.network "forwarded_port", guest: 3010, host: 3010 # Backend API port

    # Sync folder for backend
    backend.vm.synced_folder "data/e4l/", "/home/vagrant/e4l/"
    backend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox provider specific configuration
    backend.vm.provider "virtualbox" do |vb|
      vb.memory = "2048" 
      vb.cpus = 1 
    end

    config.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
   SHELL

    # Provisioning using Ansible for backend
    backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/backend_setup.yml"
    end
  end

  # Frontend VM configuration
  config.vm.define "frontend" do |frontend|
    frontend.vm.box = "ubuntu/jammy64"
    frontend.vm.hostname = "frontend"

    # Private network for frontend
    frontend.vm.network "private_network", ip: "192.168.56.11" # Frontend IP
    frontend.vm.network "forwarded_port", guest: 8088, host: 8088 # Frontend App port

    # Sync folder for frontend
    frontend.vm.synced_folder "data/e4l/", "/home/vagrant/e4l/"
    frontend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox provider specific configuration
    frontend.vm.provider "virtualbox" do |vb|
      vb.memory = "2048" 
      vb.cpus = 1        
    end

    # Provisioning using Ansible for frontend
    frontend.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/frontend_setup.yml"
    end
  end

end
