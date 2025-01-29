#!/bin/bash

# Install GitLab Runner
echo "Installing GitLab Runner..."
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner -y

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
PERSONAL_TOKEN=$(sudo gitlab-rails runner "
token = User.find_by_username('user1').personal_access_tokens.create(
  scopes: ['api'],
  name: 'token',
  expires_at: 365.days.from_now
); 
token.set_token('token'); 
token.save!;
puts token.token;
")

echo $PERSONAL_TOKEN > /vagrant_data/shared/personal_access_token.txt
chmod 0644 /vagrant_data/shared/personal_access_token.txt

# Create a GitLab project with user1
echo "Creating GitLab project..."
URL="http://192.168.56.12/gitlab/api/v4/projects"
curl --header "Private-Token: $PERSONAL_TOKEN" --data 'name=E4L&visibility=public' ${URL}

SSH_PUBLIC_KEY_PATH="/vagrant_data/shared/gitlab_rsa.pub"

echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -C "user1@example.com" -f "$SSH_KEY_PATH" -N "" <<< "y"

cp '/home/vagrant/.ssh/gitlab_rsa.pub' $SSH_PUBLIC_KEY_PATH

echo "Adding SSH key to GitLab..."
curl --request POST --header "PRIVATE-TOKEN: $PERSONAL_TOKEN" \
  --form "title=My SSH Key" \
  --form "key=$(cat $SSH_PUBLIC_KEY_PATH)" \
  "http://192.168.56.12/gitlab/api/v4/user/keys"



# Retrieve the GitLab Runner registration token
echo "Retrieving GitLab Runner registration token..."
#URL="http://192.168.56.12/gitlab/api/v4/runners/registration_token"
RUNNER_TOKEN=$(curl --header "Private-Token: $PERSONAL_TOKEN" ${URL} | grep -oP '"runners_token":\s*"\K[^"]+')
echo RUNNER_TOKEN
#echo $RUNNER_TOKEN > /vagrant_data/shared/runner_access_token.txt

RUNNER_TOKEN_FILE=/vagrant_data/shared/runner_access_token.txt
if [ ! -f "$RUNNER_TOKEN_FILE" ]; then
  echo "Creating $RUNNER_TOKEN_FILE..."
  touch "$RUNNER_TOKEN_FILE"
  chmod 0644 "$RUNNER_TOKEN_FILE"
fi

# Wait for the token to be provided manually
echo "Waiting for RUNNER_TOKEN to be set in $RUNNER_TOKEN_FILE..."
while true; do
  RUNNER_TOKEN=$(cat "$RUNNER_TOKEN_FILE" | tr -d '[:space:]') # Read and trim whitespace
  if [ -n "$RUNNER_TOKEN" ]; then
    echo "RUNNER_TOKEN detected: $RUNNER_TOKEN"
    break
  fi
  sleep 5 # Wait 5 seconds before checking again
done

# Register GitLab Runner with the retrieved token
echo "Registering GitLab Runner with the token..."
gitlab-runner register --non-interactive \
  --url "http://192.168.56.12/gitlab" \
  --registration-token "$RUNNER_TOKEN" \
  --description "docker" \
  --tag-list "integration" \
  --executor "docker" \
  --docker-image "docker:stable" \
  --run-untagged="true" \

echo "GitLab Runner registration completed successfully."

# Success message
echo "GitLab Runner setup, user creation, and project setup completed successfully!"
