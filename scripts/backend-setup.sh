#!/bin/bash

# Source global variables
source /home/vagrant/scripts/config_global_vars.sh

# Update package lists
sudo apt-get update -y

# Install basic packages
sudo apt-get install -y "${BASIC_PACKAGES[@]}"

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
  echo "++++++++++Installing jdk-$JDK_VERSION...++++++++++"
  wget "https://download.oracle.com/java/$JDK_VERSION/archive/jdk-${JDK_VERSION}.0.2_linux-x64_bin.deb" -O jdk-${JDK_VERSION}.0.2.deb
  sudo dpkg -i jdk-${JDK_VERSION}.0.2.deb
  sudo apt --fix-broken install -y
else
  echo "----------jdk-$JDK_VERSION is already installed.----------"
fi

# Set up update-alternatives for jdk-20
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-$JDK_VERSION/bin/java" 1
sudo update-alternatives --set java /usr/lib/jvm/jdk-$JDK_VERSION/bin/java

# Set JAVA_HOME environment variable
echo "export JAVA_HOME=/usr/lib/jvm/jdk-$JDK_VERSION" | sudo tee -a /etc/profile
source /etc/profile

# Install Gradle if not already installed
if [ ! -d "/opt/gradle/gradle-$GRADLE_VERSION" ]; then
  echo "++++++++++Installing Gradle $GRADLE_VERSION...++++++++++"
  wget "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
  sudo mkdir /opt/gradle
  sudo unzip -d /opt/gradle gradle-$GRADLE_VERSION-bin.zip
  echo "export PATH=\$PATH:/opt/gradle/gradle-$GRADLE_VERSION/bin" | sudo tee -a /etc/profile.d/gradle.sh
else
  echo "----------Gradle $GRADLE_VERSION is already installed.----------"
fi

source /etc/profile.d/gradle.sh

# Install MySQL server
if ! dpkg -s mysql-server &> /dev/null; then
  echo "++++++++++Installing MySQL server...++++++++++"
  
  # Preconfigure MySQL server for non-interactive installation
  export DEBIAN_FRONTEND="noninteractive"
  echo "mysql-server mysql-server/root_password password $DB_PASSWORD" | sudo debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $DB_PASSWORD" | sudo debconf-set-selections

  # Install MySQL server
  sudo apt-get install -y mysql-server
  
  # Ensure MySQL service is started and to start on boot
  sudo systemctl start mysql
  sudo systemctl enable mysql
  
  echo "----------MySQL server installed and running.----------"
else
  echo "----------mysql-server is already installed.----------"
fi

# Check and replace each property line if it exists, or add it if it doesn't
PROPERTIES_FILE="/home/vagrant/e4l/src/main/resources/application.properties"

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
mysql -u $DB_USERNAME -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS e4l;"

# Grant permissions for Gradle wrapper and run backend
echo "++++++++++Running backend setup commands...++++++++++"
cd /home/vagrant/e4l/
./gradlew wrapper
chmod +x gradlew
./gradlew clean build
