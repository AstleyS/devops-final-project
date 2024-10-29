#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install required packages
sudo apt-get install -y curl software-properties-common apt-transport-https ca-certificates gnupg-agent python3 make wget unzip

 
############## FRONTEND ##############

# Check if Node.js 15.14.0 is installed
if ! command -v node &> /dev/null || [[ $(node -v) != v15.14.0 ]]; then
  echo "++++++++++ Installing Node.js 15.14.0... ++++++++++"  
  # Install nvm if not already installed
  if ! command -v nvm &> /dev/null; then
    echo "++++++++++ Installing nvm... ++++++++++"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    # Load nvm into the current shell session
    source ~/.nvm/nvm.sh
  fi

  # Install Node.js 15.14.0 using nvm
  nvm install 15.14.0
  nvm use 15.14.0
  nvm alias default 15.14.0
else
  echo "---------- Node.js 15.14.0 is already installed. ----------"
fi

# Check if npm 7.7.6 is installed
if [[ $(npm -v) != 7.7.6 ]]; then
  echo "++++++++++ Installing npm 7.7.6... ++++++++++"
  npm install -g npm@7.7.6
else
  echo "---------- npm 7.7.6 is already installed. ----------"
fi


############## BACKEND ############## 

# Install default-jre if not already installed
if ! dpkg -s default-jre &> /dev/null; then
  echo "++++++++++Installing default-jre...++++++++++"
  sudo apt-get install -y default-jre
else
  echo "----------default-jre is already installed.----------"
fi

# Install openjdk-20-jdk if not already installed
if ! dpkg -s openjdk-17-jdk &> /dev/null; then
  echo "++++++++++Installing openjdk-17-jdk...++++++++++"
  sudo apt-get install -y openjdk-17-jdk
else
  echo "----------openjdk-19/20-jdk is already installed.----------"
fi

# Install Gradle 8.3 if not already installed
if [ ! -d "/opt/gradle/gradle-8.3" ]; then
  echo "++++++++++Installing Gradle 8.3...++++++++++"
  sudo apt-get install -y wget unzip
  wget https://services.gradle.org/distributions/gradle-8.3-bin.zip
  sudo mkdir /opt/gradle
  sudo unzip -d /opt/gradle gradle-8.3-bin.zip
  echo 'export PATH=$PATH:/opt/gradle/gradle-8.3/bin' | sudo tee -a /etc/profile.d/gradle.sh
  source /etc/profile.d/gradle.sh
else
  echo "----------Gradle 8.3 is already installed.----------"
fi


# Install MySQL server
if ! dpkg -s mysql-server &> /dev/null; then
  echo "++++++++++Installing MySQL server...++++++++++"
  
  # Preconfigure MySQL server for non-interactive installation
  export DEBIAN_FRONTEND="noninteractive"
  echo "mysql-server mysql-server/root_password password 12345678" | sudo debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password 12345678" | sudo debconf-set-selections

  # Install MySQL server
  sudo apt-get install -y mysql-server
  
  # Ensure MySQL service is started and to start on boot
  sudo systemctl start mysql
  sudo systemctl enable mysql
  
  echo "----------MySQL server installed and running.----------"
else
  echo "----------mysql-server is already installed.----------"
fi



## Configure MySQL and application.properties
#echo "++++++++++Configuring MySQL and application.properties...++++++++++"
#sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null <<EOF
#[mysqld]
#bind-address = 0.0.0.0
#EOF
#
#sudo systemctl restart mysql
#
#if ! grep -q 'spring.datasource.url=jdbc:mysql://localhost:3306/e4l' /home/vagrant/e4l/lu.uni.e4l.platform.api.dev/src/main/resources/application.properties; then
#  echo "++++++++++Configuring DB in application.properties...++++++++++"
#  echo "spring.datasource.url=jdbc:mysql://localhost:3306/e4l" | sudo tee -a /home/vagrant/e4l/lu.uni.e4l.platform.api.dev/src/main/resources/application.properties
#  echo "spring.datasource.username=root" | sudo tee -a /home/vagrant/e4l/lu.uni.e4l.platform.api.dev/src/main/resources/application.properties
#  echo "spring.datasource.password=12345678" | sudo tee -a /home/vagrant/e4l/lu.uni.e4l.platform.api.dev/src/main/resources/application.properties
#
#  # Create the database "e4l" in MySQL
#  echo "++++++++++Creating DB...++++++++++"
#  mysql -u root -p12345678 -e "CREATE DATABASE IF NOT EXISTS e4l;"
#else
#  echo "----------DB is already configured in application.properties.----------"
#fi
#
## Configure .env file for frontend
#ENV_FILE="/home/vagrant/e4l/lu.uni.e4l.platform.frontend.dev/.env"
#API_URL="http://192.168.56.5:8084/e4lapi/"
#if [ ! -f "$ENV_FILE" ]; then
#  echo "++++++++++Configuring .env file for frontend...++++++++++"
#  echo "API_URL=$API_URL" | sudo tee -a "$ENV_FILE"
#else
#  grep -qxF "API_URL=$API_URL" "$ENV_FILE" || echo "API_URL=$API_URL" | sudo tee -a "$ENV_FILE"
#fi
#
## Install GitLab and GitLab Runner
##echo "++++++++++Installing GitLab and GitLab Runner...++++++++++"
##curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
##sudo apt-get install -y gitlab-ee
##
##curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
##sudo apt-get install -y gitlab-runner
#
#echo "Provisioning complete."
