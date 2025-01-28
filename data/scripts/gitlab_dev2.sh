# Configuration Variables
INTEGRATION_URL="http://192.168.56.12/gitlab"
PROJECT_NAME="E4L"
USERNAME1="user1"
USERNAME2="user2"
EMAIL1="user1@example.com"
EMAIL2="user2@example.com"
TOKEN_FILE="/vagrant_data/shared/personal_access_token.txt"
PROJECT_DIR="/vagrant_data/projects/${PROJECT_NAME}"

# Configure Git for User 2
echo "Configuring Git for $USERNAME2..."
git config --global user.name "$USERNAME2"
git config --global user.email "$EMAIL2"

# Clone the GitLab Project for User 2
if [ ! -d "$PROJECT_DIR" ]; then
  echo "Cloning the GitLab project for $USERNAME2..."
  git clone "http://$USERNAME2:$TOKEN2@$INTEGRATION_URL/${USERNAME1}/${PROJECT_NAME}.git" "$PROJECT_DIR"
else
  echo "Project directory for $USERNAME2 already exists. Pulling latest changes..."
  cd "$PROJECT_DIR" || exit
  git pull
fi

# Create a Sample Change for User 2
echo "Making changes to the project for $USERNAME2..."
cd "$PROJECT_DIR" || exit
echo "# Dev Environment Setup by $USERNAME2" >> README.md

# Commit and Push Changes for User 2
echo "Committing and pushing changes for $USERNAME2..."
git add README.md
git commit -m "Update README with dev environment setup details by $USERNAME2"
git push origin main