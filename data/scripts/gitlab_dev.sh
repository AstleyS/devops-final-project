#!/bin/bash

# Configuration Variables
INTEGRATION_URL="http://192.168.56.12/gitlab"
PROJECT_NAME="e4l"
USERNAME1="user1"
USERNAME2="user2"
EMAIL1="user1@example.com"
EMAIL2="user2@example.com"
TOKEN_FILE="/vagrant_data/shared/personal_access_token.txt"
PROJECT_DIR="/vagrant_data/${PROJECT_NAME}"
FRONTEND_DIR="{{ PROJECT_DIR }}/lu.uni.e4l.platform.frontend.dev"


# Ensure the personal access token file exists
if [ ! -f "$TOKEN_FILE" ]; then
  echo "Personal access token file not found at $TOKEN_FILE. Exiting."
  exit 1
fi

# Read personal access tokens for both users
TOKEN1=$(sed -n '1p' "$TOKEN_FILE")

SSH_KEY_PATH1="/home/vagrant/.ssh/gitlab_rsa1"
SSH_KEY_PATH2="/home/vagrant/.ssh/gitlab_rsa2"
SSH_PUBLIC_KEY_PATH1="/vagrant_data/shared/gitlab_rsa1.pub"
SSH_PUBLIC_KEY_PATH2="/vagrant_data/shared/gitlab_rsa2.pub"

echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -C "user1@example.com" -f "$SSH_KEY_PATH1" -N "" <<< "y"
ssh-keygen -t rsa -b 4096 -C "astley_394@hotmail.com" -f "$SSH_KEY_PATH2" -N "" <<< "y"


cp '/home/vagrant/.ssh/gitlab_rsa1.pub' $SSH_PUBLIC_KEY_PATH1
cp '/home/vagrant/.ssh/gitlab_rsa2.pub' $SSH_PUBLIC_KEY_PATH2

# Start SSH agent and add keys
echo "Starting SSH agent and adding keys..."
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY_PATH1"
ssh-add "$SSH_KEY_PATH2"

# Update SSH config
echo "Configuring SSH for GitLab..."
cat <<EOF >> /home/vagrant/.ssh/config

  Host gitlab
      HostName 192.168.56.12
      User git
      IdentityFile $SSH_KEY_PATH1
      IdentitiesOnly yes

  Host gitlab-alt
      HostName 192.168.56.12
      User git
      IdentityFile $SSH_KEY_PATH2
      IdentitiesOnly yes

EOF

chmod 600 /home/vagrant/.ssh/config

echo "Adding SSH key to GitLab..."
curl --request POST --header "PRIVATE-TOKEN: $PERSONAL_TOKEN" \
  --form "title=My SSH Key1" \
  --form "key=$(cat $SSH_PUBLIC_KEY_PATH1)" \
  "http://192.168.56.12/gitlab/api/v4/user/keys"


curl --request POST --header "PRIVATE-TOKEN: $PERSONAL_TOKEN" \
  --form "title=My SSH Key2" \
  --form "key=$(cat $SSH_PUBLIC_KEY_PATH2)" \
  "http://192.168.56.12/gitlab/api/v4/user/keys"



# Configure Git for User 1
cd /vagrant_data/e4l/lu.uni.e4l.platform.frontend.dev
cp /vagrant_data/scripts/.gitlab-ci.yml .
echo "Configuring Git for $USERNAME1..."
git config --global user.name "$USERNAME1"
git config --global user.email "$EMAIL1"

git init --initial-branch=main
git remote add origin  http://192.168.56.12/gitlab/user1/e4l.git
git add .
git commit -m "Initial commit"

## Clone the GitLab Project for User 1
#if [ ! -d "$PROJECT_DIR" ]; then
#  echo "Cloning the GitLab project for $USERNAME1..."
#  git clone "git@192.168.56.12:${USERNAME1}/${PROJECT_NAME}.git" "$PROJECT_DIR"
#else
#  echo "Project directory for $USERNAME1 already exists. Pulling latest changes..."
#  cd "$PROJECT_DIR" || exit
#  git pull
#fi
#
## Changes for User 1
#echo "Making changes to the project for $USERNAME1..."
#cd "$FRONTEND_DIR" || exit
#echo "# Dev Environment Setup by $USERNAME1" >> README.md
#
## Commit and Push Changes for User 1
#echo "Committing and pushing changes for $USERNAME1..."
#git add README.md
#git commit -m "Update README with dev environment setup details by $USERNAME1"
#git push origin main
#
#echo "Git setup, pull, commit, and push completed successfully for both $USERNAME1."
#
echo "Git setup successfully for $USERNAME1."