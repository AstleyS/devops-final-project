#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install required packages
sudo apt-get install -y curl software-properties-common apt-transport-https ca-certificates gnupg-agent python3 make wget unzip dpkg


############## BACKEND ############## 

# Install default-jre if not already installed
if ! dpkg -s default-jre &> /dev/null; then
  echo "++++++++++Installing default-jre...++++++++++"
  sudo apt-get install -y default-jre
else
  echo "----------default-jre is already installed.----------"
fi

# Install openjdk-20-jdk if not already installed
if ! dpkg -s jdk-20 &> /dev/null; then
  echo "++++++++++Installing jdk-20...++++++++++"
  wget https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-x64_bin.deb -O jdk-20.0.2.deb
  sudo dpkg -i jdk-20.0.2.deb
  sudo apt --fix-broken install -y
else
  echo "----------jdk-20 is already installed.----------"
fi

# Set up update-alternatives for jdk-20
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-20/bin/java" 1
sudo update-alternatives --set java /usr/lib/jvm/jdk-20/bin/java

# Set JAVA_HOME environment variable
echo "export JAVA_HOME=/usr/lib/jvm/jdk-20" | sudo tee -a /etc/profile
source /etc/profile


# Install Gradle 8.3 if not already installed
if [ ! -d "/opt/gradle/gradle-8.3" ]; then
  echo "++++++++++Installing Gradle 8.3...++++++++++"
  wget https://services.gradle.org/distributions/gradle-8.3-bin.zip
  sudo mkdir /opt/gradle
  sudo unzip -d /opt/gradle gradle-8.3-bin.zip
  echo 'export PATH=$PATH:/opt/gradle/gradle-8.3/bin' | sudo tee -a /etc/profile.d/gradle.sh
else
  echo "----------Gradle 8.3 is already installed.----------"
fi

source /etc/profile.d/gradle.sh

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

# Define your database properties
DB_URL="jdbc:mysql://localhost:3306/e4l"
DB_USERNAME="root"
DB_PASSWORD="12345678"

PROPERTIES_FILE="/home/vagrant/e4l/src/main/resources/application.properties"

# Check and replace each property line if it exists, or add it if it doesn't
if grep -q "^spring.datasource.url=" "$PROPERTIES_FILE"; then
    sed -i "s|^spring.datasource.url=.*|spring.datasource.url=${DB_URL}|" "$PROPERTIES_FILE"
else
    echo "spring.datasource.url=${DB_URL}" >> "$PROPERTIES_FILE"
fi

if grep -q "^spring.datasource.username=" "$PROPERTIES_FILE"; then
    sed -i "s|^spring.datasource.username=.*|spring.datasource.username=${DB_USERNAME}|" "$PROPERTIES_FILE"
else
    echo "spring.datasource.username=${DB_USERNAME}" >> "$PROPERTIES_FILE"
fi

if grep -q "^spring.datasource.password=" "$PROPERTIES_FILE"; then
    sed -i "s|^spring.datasource.password=.*|spring.datasource.password=${DB_PASSWORD}|" "$PROPERTIES_FILE"
else
    echo "spring.datasource.password=${DB_PASSWORD}" >> "$PROPERTIES_FILE"
fi


# Create the e4l database
echo "++++++++++Creating e4l database...++++++++++"
mysql -u root -p12345678 -e "CREATE DATABASE IF NOT EXISTS e4l;"


# Grant permissions for Gradle wrapper and run backend
echo "++++++++++Running backend setup commands...++++++++++"
cd /home/vagrant/e4l/
./gradlew wrapper
chmod +x gradlew
./gradlew clean build

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
