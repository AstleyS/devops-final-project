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

# Configure Git for User 1
echo "Configuring Git for $USERNAME1..."
git config --global user.name "$USERNAME1"
git config --global user.email "$EMAIL1"

# Clone the GitLab Project for User 1
if [ ! -d "$PROJECT_DIR" ]; then
  echo "Cloning the GitLab project for $USERNAME1..."
  git clone "git@192.168.56.12:${USERNAME1}/${PROJECT_NAME}.git" "$PROJECT_DIR"
else
  echo "Project directory for $USERNAME1 already exists. Pulling latest changes..."
  cd "$PROJECT_DIR" || exit
  git pull
fi

# Changes for User 1
echo "Making changes to the project for $USERNAME1..."
cd "$FRONTEND_DIR" || exit
echo "# Dev Environment Setup by $USERNAME1" >> README.md

# Commit and Push Changes for User 1
echo "Committing and pushing changes for $USERNAME1..."
git add README.md
git commit -m "Update README with dev environment setup details by $USERNAME1"
git push origin main

echo "Git setup, pull, commit, and push completed successfully for both $USERNAME1."
