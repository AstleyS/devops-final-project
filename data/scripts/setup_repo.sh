#!/bin/bash

# Set variables
PROJECT_DIR="/home/vagrant/e4l"
GIT_URL="http://192.168.56.5/gitlab/user/e4l"
GIT_USERNAME="user"
GIT_PASSWORD="password"
GIT_ACCESS_TOKEN="AvuTEsPPoPo7_cd5a9EQ"

# Init local git project
cd $PROJECT_DIR
git init
git remote add origin http://${GIT_USERNAME}:${GIT_ACCESS_TOKEN}@${GIT_URL}

# Configure the git user
git config --global user.name "$GIT_USERNAME"
git config --global user.email "user@user.com"

# Create a .gitignore file to avoid committing logs, dev settings, and binaries 
echo '# Binaries
target/

# Log files
*.log

# Dev settings
.settings' > .gitignore

# Push the project
git add .
git commit -m "Initial Commit"
git push origin master
