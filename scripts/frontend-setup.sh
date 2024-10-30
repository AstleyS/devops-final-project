#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install required packages
sudo apt-get install -y curl software-properties-common apt-transport-https ca-certificates gnupg-agent python3 make wget unzip dpkg

 
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

## Configure .env file for frontend
ENV_FILE="/home/vagrant/e4l/.env"
API_URL="http://192.168.56.11:3001/e4lapi/"

if [ ! -f "$ENV_FILE" ]; then
  echo "++++++++++Configuring .env file for frontend...++++++++++"
  echo "API_URL=$API_URL" | sudo tee -a "$ENV_FILE"
else
  # Replace existing API_URL or add if not found
  if grep -q "^API_URL=" "$ENV_FILE"; then
    sudo sed -i "s|^API_URL=.*|API_URL=$API_URL|" "$ENV_FILE"
  else
    echo "API_URL=$API_URL" | sudo tee -a "$ENV_FILE"
  fi
fi

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
