# config_global_vars.sh

# Frontend configuration
FRONTEND_IP="192.168.56.11"
API_URL="http://$FRONTEND_IP:8080/e4lapi/"

# Backend configuration
BACKEND_IP="192.168.56.10"
DB_URL="jdbc:mysql://localhost:3306/e4l"
DB_USERNAME="root"
DB_PASSWORD="12345678"

# Install package list
BASIC_PACKAGES=(
    curl
    software-properties-common
    apt-transport-https
    ca-certificates
    gnupg-agent
    python3
    make
    wget
    unzip
    dpkg
)

# Node.js and npm versions
NODE_VERSION="15.14.0"
NPM_VERSION="7.7.6"

# Java and Gradle versions
JDK_VERSION="20"
GRADLE_VERSION="8.3"
