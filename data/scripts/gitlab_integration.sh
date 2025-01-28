#!/bin/bash

# Install GitLab Runner
echo "Installing GitLab Runner..."
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner -y

# Register GitLab Runner (initial registration)
echo "Registering GitLab Runner..."
gitlab-runner register

# Reset GitLab root password using Rails
echo "Resetting GitLab root password..."
sudo gitlab-rails console <<EOF
user = User.find_by_username('root')
user.password = 'vagrant1234'
user.password_confirmation = 'vagrant1234'
user.save!
EOF

# Create GitLab User1
echo "Creating GitLab User1..."
sudo gitlab-rails console <<EOF
u = User.new(
  username: 'user1',
  email: 'user1@example.com',
  name: 'User 1',
  password: 'vagrant1234',
  password_confirmation: 'vagrant1234'
)
u.assign_personal_namespace(Organizations::Organization.default_organization)
u.skip_confirmation! # Skip confirmation if desired
u.save!
EOF

# Create GitLab User2
echo "Creating GitLab User2..."
sudo gitlab-rails console <<EOF
u = User.new(
  username: 'user2',
  email: 'user2@example.com',
  name: 'User 2',
  password: 'vagrant1234',
  password_confirmation: 'vagrant1234'
)
u.assign_personal_namespace(Organizations::Organization.default_organization)
u.skip_confirmation! # Skip confirmation if desired
u.save!
EOF

# Retrieve personal access token for user1
echo "Retrieving personal access token for user1..."
PERSONAL_TOKEN=$(sudo gitlab-rails runner "puts User.find_by(username: 'user1').personal_access_tokens.create(scopes: [:api], name: 'token').token")
echo $PERSONAL_TOKEN > /vagrant_data/shared/personal_access_token.txt
chmod 0644 /vagrant_data/shared/personal_access_token.txt

# Create a GitLab project with user1
echo "Creating GitLab project..."
URL="http://192.168.56.12/gitlab/api/v4/projects"
curl --header "Private-Token: $PERSONAL_TOKEN" --data 'name=E4L&visibility=public' ${URL}

# Retrieve the GitLab Runner registration token
echo "Retrieving GitLab Runner registration token..."
URL="http://192.168.56.12/gitlab/api/v4/runners/registration_token"
RUNNER_TOKEN=$(curl --header "Private-Token: $PERSONAL_TOKEN" ${URL} | jq -r '.token')
echo $RUNNER_TOKEN > /vagrant_data/shared/runner_access_token.txt
chmod 0644 /vagrant_data/shared/runner_access_token.txt

# Register GitLab Runner with the retrieved token
echo "Registering GitLab Runner with the token..."
gitlab-runner register --non-interactive \
  --url "http://192.168.56.12/gitlab" \
  --registration-token "$RUNNER_TOKEN" \
  --executor "shell" \
  --description "gitlab-runner-1" \
  --tag-list "dev" \
  --run-untagged="true" \

echo "GitLab Runner registration completed successfully."

# Success message
echo "GitLab Runner setup, user creation, and project setup completed successfully!"
