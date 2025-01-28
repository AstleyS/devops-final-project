#!/bin/bash

# Define environment variables
BACKEND_IP="192.168.56.10"
BACKEND_PORT=3010
BACKEND_DIR="/vagrant_data/e4l/lu.uni.e4l.platform.api.dev"

FRONTEND_IP="192.168.56.11"
FRONTEND_PORT=8088
FRONTEND_DIR="/vagrant_data/e4l/lu.uni.e4l.platform.frontend.dev"

INTEGRATION_IP="192.168.56.12"
INTEGRATION_PORT=8088
INTEGRATION_DIR="/home/vagrant/integration"
INTEGRATION_URL="http://$INTEGRATION_IP/gitlab"

STAGING_IP="192.168.56.13"
STAGING_PORT=8088
STAGING_DIR="/home/vagrant/staging"

PRODUCTION_IP="192.168.56.14"
PRODUCTION_PORT=8088
PRODUCTION_DIR="/home/vagrant/production"

# Check if a service is running
# Function to check if a URL returns 200
check_service() {
  local url=$1
  echo "Checking if $url is up..."
  until curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; do
    echo "Waiting for $url to be ready..."
    sleep 10
  done
  echo "$url is up!"
}


# Check if the Integration server is up

# Start Integration Environment
echo "Starting Integration Environment..."
cd environments/integration 
gnome-terminal --tab --title="Integration Server" -- bash -c "vagrant up && vagrant ssh; exec bash"
check_service "$INTEGRATION_URL"


# Start Development Environment
#echo "Starting Development Environment..."
#cd ../environments/dev
#vagrant up dev-frontend #dev-backend
#check_service $FRONTEND_IP $FRONTEND_PORT

# Halt Development Environment to free resources
# echo "Halting Development Environment..."
# vagrant halt dev-frontend dev-backend

# Start Staging Environment
#echo "Starting Staging Environment..."
#vagrant up staging
#check_service $STAGING_IP $STAGING_PORT

# Start Production Environment
#echo "Starting Production Environment..."
#vagrant up production
#check_service $PRODUCTION_IP $PRODUCTION_PORT

echo "All environments are up and running!"
