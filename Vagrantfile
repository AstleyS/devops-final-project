require 'yaml'

# Load global configuration variables from YAML
config_vars = YAML.load_file('scripts/config_global_vars.yml')

Vagrant.configure("2") do |config|

  '''
  DEV ENVIRONMENT: BACKEND AND FRONTEND
  '''

  # Backend VM configuration
  config.vm.define "dev-backend" do |dev_backend|
    dev_backend.vm.box = "ubuntu/jammy64"
    dev_backend.vm.hostname = "dev-backend"

    # Private network for backend
    dev_backend.vm.network "private_network", ip: config_vars['BACKEND_IP']
    dev_backend.vm.network "forwarded_port", guest: config_vars['BACKEND_PORT'], host: config_vars['BACKEND_PORT']

    # Sync folder for backend
    dev_backend.vm.synced_folder "data/e4l/", "/e4l/"
    dev_backend.vm.synced_folder "data/dev/backend", "/home/vagrant/e4l"
    dev_backend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    dev_backend.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    # Provisioning
    dev_backend.vm.provision "shell", inline: <<-SHELL
      unzip -o /e4l/lu.uni.e4l.platform.api.dev.zip -d /home/vagrant/e4l/

      mv /home/vagrant/e4l/.gitlab-ci.yml /home/vagrant/e4l/lu.uni.e4l.platform.api.dev/
    SHELL


    # Provisioning
    dev_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/dev/backend_setup.yml"
    end


  end

  # Frontend VM configuration
  config.vm.define "dev-frontend" do |dev_frontend|
    dev_frontend.vm.box = "ubuntu/jammy64"
    dev_frontend.vm.hostname = "dev-frontend"

    # Private network for frontend
    dev_frontend.vm.network "private_network", ip: config_vars['FRONTEND_IP']
    dev_frontend.vm.network "forwarded_port", guest: config_vars['FRONTEND_PORT'], host: config_vars['FRONTEND_PORT']

    # Sync folder for frontend
    dev_frontend.vm.synced_folder "data/e4l/", "/e4l/"
    dev_frontend.vm.synced_folder "data/dev/frontend", "/home/vagrant/e4l"
    dev_frontend.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    dev_frontend.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    dev_frontend.vm.provision "shell", inline: <<-SHELL
      unzip -o /e4l/lu.uni.e4l.platform.frontend.dev.zip -d /home/vagrant/e4l/

      mv /home/vagrant/e4l/.gitlab-ci.yml /home/vagrant/e4l/lu.uni.e4l.platform.frontend.dev/

    SHELL

    # Provisioning
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
    integration.vm.network "private_network", ip: config_vars['INTEGRATION_IP']
    integration.vm.network "forwarded_port", guest: config_vars['INTEGRATION_PORT'], host: config_vars['INTEGRATION_PORT']

    # Sync folders
    integration.vm.synced_folder "data/integration/", "/home/vagrant/"
    integration.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    integration.vm.provider "virtualbox" do |vb|
      vb.memory = "5440"
      vb.cpus = 4
    end

    # Provisioning
    integration.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/integration/integration_setup.yml"
    end

  end

  '''
  STAGING ENVIRONMENT
  '''
  config.vm.define "staging" do |staging|
    staging.vm.box = "ubuntu/jammy64"
    staging.vm.hostname = "staging"

    # Private network for staging
    staging.vm.network "private_network", ip: config_vars['STAGING_IP']
    staging.vm.network "forwarded_port", guest: config_vars['STAGING_PORT'], host: config_vars['STAGING_PORT']

    # Sync folders
    staging.vm.synced_folder "data/staging/", "/home/vagrant/"
    staging.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    staging.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    # Provisioning
    staging.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/staging/staging_setup.yml"
    end
  end

  '''
  PRODUCTION ENVIRONMENT
  '''
  config.vm.define "production" do |production|
    production.vm.box = "ubuntu/jammy64"
    production.vm.hostname = "production"

    # Private network for production
    production.vm.network "private_network", ip: config_vars['PRODUCTION_IP']
    production.vm.network "forwarded_port", guest: config_vars['PRODUCTION_PORT'], host: config_vars['PRODUCTION_PORT']

    # Sync folders
    production.vm.synced_folder "data/production/", "/home/vagrant/"
    production.vm.synced_folder "scripts", "/home/vagrant/scripts"

    # VirtualBox configuration
    production.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end

    # Provisioning
    production.vm.provision "ansible" do |ansible|
      ansible.playbook = "scripts/ansible/production/production_setup.yml"
    end
  end

end
