#!/bin/bash

# Define environment variables
BACKEND_IP="192.168.56.10"
BACKEND_PORT=3010
BACKEND_DIR="/home/vagrant/e4l/lu.uni.e4l.platform.api.dev"

FRONTEND_IP="192.168.56.11"
FRONTEND_PORT=8088
FRONTEND_DIR="/home/vagrant/e4l/lu.uni.e4l.platform.frontend.dev"

INTEGRATION_IP="192.168.56.12"
INTEGRATION_PORT=8089
INTEGRATION_DIR="/home/vagrant/integration"

STAGING_IP="192.168.56.13"
STAGING_PORT=8090
STAGING_DIR="/home/vagrant/staging"

PRODUCTION_IP="192.168.56.14"
PRODUCTION_PORT=8091
PRODUCTION_DIR="/home/vagrant/production"

# Check if a service is running
check_service() {
  local ip=$1
  local port=$2
  echo "Checking service at ${ip}:${port}..."
  
  while ! netstat -an | grep -q "${ip}:${port}"; do
    echo "Service at ${ip}:${port} not available. Retrying in 5 seconds..."
    sleep 5
  done
  echo "Service at ${ip}:${port} is up!"
}


# Start Integration Environment
echo "Starting Integration Environment..."
vagrant up integration
check_service $INTEGRATION_IP $INTEGRATION_PORT


# Start Development Environment
echo "Starting Development Environment..."
vagrant up dev-frontend dev-backend
#check_service $FRONTEND_IP $FRONTEND_PORT

# Halt Development Environment to free resources
echo "Halting Development Environment..."
vagrant halt dev-frontend dev-backend

# Start Staging Environment
#echo "Starting Staging Environment..."
#vagrant up staging
#check_service $STAGING_IP $STAGING_PORT

# Start Production Environment
#echo "Starting Production Environment..."
#vagrant up production
#check_service $PRODUCTION_IP $PRODUCTION_PORT

echo "All environments are up and running!"
