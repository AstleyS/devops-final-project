# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  '''

  DEV ENVIRONMENT: BACKEND AND FRONTEND

  '''
  
  ######### BACKEND VM configuration #########


  config.vm.define "dev-backend" do |dev_backend|
    dev_backend.vm.box = "ubuntu/jammy64"
    dev_backend.vm.hostname = "dev-backend"

    # Private network for backend
    dev_backend.vm.network "private_network", ip: "192.168.56.10" # Backend IP
    dev_backend.vm.network "forwarded_port", guest: 3010, host: 3010 # Backend API port

    # Sync folder for backend
    dev_backend.vm.synced_folder "data/e4l/", "/home/vagrant/e4l/"
    dev_backend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox provider specific configuration
    dev_backend.vm.provider "virtualbox" do |vb|
      vb.memory = "4096" 
      vb.cpus = 2 
    end

    #config.vm.provision "shell", inline: <<-SHELL
    #  sudo apt-get update -y
   #SHELL

    # Provisioning using Ansible for backend
    dev_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/dev/backend_setup.yml"
    end
  end

  
  ######### FRONTEND VM configuration #########


  config.vm.define "dev-frontend" do |dev_frontend|
    dev_frontend.vm.box = "ubuntu/jammy64"
    dev_frontend.vm.hostname = "dev-frontend"

    # Private network for frontend
    dev_frontend.vm.network "private_network", ip: "192.168.56.11" # Frontend IP
    dev_frontend.vm.network "forwarded_port", guest: 8088, host: 8088 # Frontend App port

    # Sync folder for frontend
    dev_frontend.vm.synced_folder "data/e4l/", "/home/vagrant/e4l/"
    dev_frontend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox provider specific configuration
    dev_frontend.vm.provider "virtualbox" do |vb|
      vb.memory = "4096" 
      vb.cpus = 2        
    end

    # Provisioning using Ansible for frontend
    dev_frontend.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/dev/frontend_setup.yml"
    end
  end


  '''
  INTEGRATION ENVIRONMENT

  '''

  config.vm.define "integration" do |integration|
    integration.vm.box = "ubuntu/jammy64"
    integration.vm.hostname = "integration"

    # Private network for integration
    integration.vm.network "private_network", ip: "192.168.56.12" # Integration IP
    integration.vm.network "forwarded_port", guest: 8089, host: 8089 # GitLab service port

    # Sync folders
    integration.vm.synced_folder "data/integration/", "/home/vagrant/integration/"
    integration.vm.synced_folder "data/e4l/", "/home/vagrant/e4l/"
    integration.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    integration.vm.provider "virtualbox" do |vb|
      vb.memory = "5440"
      vb.cpus = 4
    end

    # Provisioning using Ansible for integration
    integration.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/integration/integration_setup.yml"
    end
  end


  '''

  STAGING ENVIRONMENT

  '''
  # Staging VM configuration
  config.vm.define "staging" do |staging|
    staging.vm.box = "ubuntu/jammy64"
    staging.vm.hostname = "staging"

    # Private network for staging
    staging.vm.network "private_network", ip: "192.168.56.30" # Staging IP

    # Sync folders
    staging.vm.synced_folder "data/staging/", "/home/vagrant/staging/"
    staging.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    staging.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    # Provisioning using Ansible for staging
    staging.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/staging/staging_setup.yml"
    end
  end


  '''

  PRODUCTION ENVIRONMENT

  '''
  # Production VM configuration
  config.vm.define "production" do |production|
    production.vm.box = "ubuntu/jammy64"
    production.vm.hostname = "production"

    # Private network for production
    production.vm.network "private_network", ip: "192.168.56.40" # Production IP

    # Sync folders
    production.vm.synced_folder "data/production/", "/home/vagrant/production/"
    production.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    production.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    # Provisioning using Ansible for production
    production.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/production/production_setup.yml"
    end
  end

end
