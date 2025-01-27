#!/bin/bash

# Source global variables
source /home/vagrant/scripts/config_global_vars.sh

# Update package lists
sudo apt-get update -y

# Install basic packages
sudo apt-get install -y "${BASIC_PACKAGES[@]}"

############## FRONTEND ##############

# Check if Node.js is installed
if ! command -v node &> /dev/null || [[ $(node -v) != v$NODE_VERSION ]]; then
  echo "++++++++++ Installing Node.js $NODE_VERSION... ++++++++++"
  # Install nvm if not already installed
  if ! command -v nvm &> /dev/null; then
    echo "++++++++++ Installing nvm... ++++++++++"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    # Add nvm to bashrc for persistence
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
  fi

  # Load nvm into the current shell session
  source ~/.nvm/nvm.sh
  source ~/.bashrc
  
  # Install and use Node.js
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
  nvm alias default $NODE_VERSION
else
  echo "---------- Node.js $NODE_VERSION is already installed. ----------"
fi

# Load nvm into the current shell session
    source ~/.nvm/nvm.sh
    source ~/.bashrc

# Check if npm is installed
if [[ $(npm -v) != $NPM_VERSION ]]; then
  echo "++++++++++ Installing npm $NPM_VERSION... ++++++++++"
  sudo npm install -g npm@$NPM_VERSION
else
  echo "---------- npm $NPM_VERSION is already installed. ----------"
fi

## Configure .env file for frontend
ENV_FILE="/home/vagrant/e4l/.env"

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
