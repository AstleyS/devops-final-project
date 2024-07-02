#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install required packages
sudo apt-get install -y curl software-properties-common apt-transport-https ca-certificates gnupg-agent python make wget unzip

# Install default-jre if not already installed
if ! dpkg -s default-jre &> /dev/null; then
  echo "Installing default-jre..."
  sudo apt-get install -y default-jre
else
  echo "default-jre is already installed."
fi

# Install openjdk-8-jdk if not already installed
if ! dpkg -s openjdk-8-jdk &> /dev/null; then
  echo "Installing openjdk-8-jdk..."
  sudo apt-get install -y openjdk-8-jdk
else
  echo "openjdk-8-jdk is already installed."
fi

# Install MySQL server
if ! dpkg -s mysql-server &> /dev/null; then
  echo "Installing MySql server..."
  export DEBIAN_FRONTEND="noninteractive"
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 12345678"
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 12345678"
  sudo apt-get install -y mysql-server
else
  echo "mysql-server is already installed."
fi

# Install Node.js 15.14.0 if not already installed
if ! command -v node &> /dev/null; then
  echo "Installing Node.js 15.14.0..."
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_15.x bionic main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  echo "deb-src [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_15.x bionic main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
  sudo apt-get install -y nodejs
else
  echo "Node.js is already installed."
fi

# Upgrade npm to version 7.7.6
sudo npm install -g npm@7.7.6

# Install Gradle 6.7.1 if not already installed
if [ ! -d "/opt/gradle/gradle-6.7.1" ]; then
  echo "Installing Gradle 6.7.1..."
  sudo apt-get install -y wget unzip
  wget https://services.gradle.org/distributions/gradle-6.7.1-bin.zip
  sudo mkdir /opt/gradle
  sudo unzip -d /opt/gradle gradle-6.7.1-bin.zip
  echo 'export PATH=$PATH:/opt/gradle/gradle-6.7.1/bin' | sudo tee -a /etc/profile.d/gradle.sh
  source /etc/profile.d/gradle.sh
else
  echo "Gradle 6.7.1 is already installed."
fi

# Configure MySQL and application.properties
echo "Configuring MySQL and application.properties..."
sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null <<EOF
[mysqld]
bind-address = 0.0.0.0
EOF

sudo systemctl restart mysql

if ! grep -q 'spring.datasource.url=jdbc:mysql://localhost:3306/e4l' /lu.uni.e4l.platform.api.dev/src/main/resources/application.properties; then
  echo "Configuring DB in application.properties..."
  echo "spring.datasource.url=jdbc:mysql://localhost:3306/e4l" | sudo tee -a /lu.uni.e4l.platform.api.dev/src/main/resources/application.properties
  echo "spring.datasource.username=root" | sudo tee -a /lu.uni.e4l.platform.api.dev/src/main/resources/application.properties
  echo "spring.datasource.password=12345678" | sudo tee -a /lu.uni.e4l.platform.api.dev/src/main/resources/application.properties

  # Create the database "e4l" in MySQL
  echo "Creating DB..."
  mysql -u root -p12345678 -e "CREATE DATABASE IF NOT EXISTS e4l;"
else
  echo "DB is already configured in application.properties."
fi

# Configure .env file for frontend
ENV_FILE="/home/vagrant/e4l/lu.uni.e4l.platform.frontend.dev/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "Configuring .env file for frontend..."
  echo "API_URL=http://localhost:8080/e4lapi" | sudo tee -a "$ENV_FILE"
else
  grep -qxF 'API_URL=http://localhost:8080/e4lapi' "$ENV_FILE" || echo "API_URL=http://localhost:8080/e4lapi" | sudo tee -a "$ENV_FILE"
fi

# Install GitLab and GitLab Runner
echo "Installing GitLab and GitLab Runner..."
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-ee

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner

sudo apt-get install gitlab-rails

echo "Provisioning complete."
