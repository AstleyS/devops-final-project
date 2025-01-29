#!/bin/bash

# Configuration Variables
INTEGRATION_URL="http://192.168.56.12/gitlab"
PROJECT_NAME="e4l-backend"
USERNAME1="user1"
USERNAME2="user2"
EMAIL1="user1@example.com"
EMAIL2="user2@example.com"
TOKEN_FILE="/vagrant_data/shared/personal_access_token.txt"
PROJECT_DIR="/vagrant_data/e4l"
FRONTEND_DIR="{{ PROJECT_DIR }}/lu.uni.e4l.platform.api.dev"


# Ensure the personal access token file exists
if [ ! -f "$TOKEN_FILE" ]; then
  echo "Personal access token file not found at $TOKEN_FILE. Exiting."
  exit 1
fi

# Read personal access tokens for both users
TOKEN1=$(sed -n '1p' "$TOKEN_FILE")

curl --request POST --header "PRIVATE-TOKEN: $PERSONAL_TOKEN" \
  --form "title=My SSH Key2" \
  --form "key=$(cat $SSH_PUBLIC_KEY_PATH2)" \
  "http://192.168.56.12/gitlab/api/v4/user/keys"


# Configure Git for User 1
# cp /vagrant_data/scripts/backend/.gitlab-ci.yml .
echo "Configuring Git for $USERNAME1..."
git config --global user.name "$USERNAME1"
git config --global user.email "$EMAIL1"
git config --global --add safe.directory /home/vagrant/e4l-backend
git config --global credential.helper store
echo "http://user1:vagrant1234@192.168.56.12" > ~/.git-credentials # This is not the secure way to store credentials. Only for this project


cd .
git clone http://192.168.56.12/gitlab/user1/e4l-backend.git
cd e4l-backend
cp -r /vagrant_data/e4l/lu.uni.e4l.platform.api.dev/* . 

git add .
git commit -m "Initial commit"
git push origin main

echo "Git setup, pull, commit, and push completed successfully for both $USERNAME1."