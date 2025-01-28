#!/bin/bash

# Download GitLab Runner
echo "Downloading GitLab Runner..."
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

# Install GitLab Runner
echo "Installing GitLab Runner..."
sudo apt-get install gitlab-runner -y

# Register GitLab Runner
echo "Registering GitLab Runner..."
gitlab-runner register

# Register Runner for user1
echo "Registering Runner for user1..."
USER1_TOKEN=$(sed -n '1p' /vagrant_data/shared/personal_access_token.txt)
gitlab-runner register --non-interactive \
  --url "${API_URL_INTEGRATION}" \
  --registration-token "$USER1_TOKEN" \
  --executor "shell" \
  --description "user1-runner"

# Register Runner for user2
echo "Registering Runner for user2..."
USER2_TOKEN=$(sed -n '2p' /vagrant_data/shared/personal_access_token.txt)
gitlab-runner register --non-interactive \
  --url "${API_URL_INTEGRATION}" \
  --registration-token "$USER2_TOKEN" \
  --executor "shell" \
  --description "user2-runner"
