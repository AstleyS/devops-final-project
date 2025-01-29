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
    sleep 120
  done
  echo "$url is up!"
}

# Restarting Ports
start_port=8088
end_port=8095

echo -e "\nRestarting ports:\n"

for port in $(seq $start_port $end_port); do
  if netstat -atlpn | grep :$port > /dev/null; then
    echo "Port $port is in use"
    fuser -k $port/tcp
    sleep 5
  else
    echo "Port $port is not in use."
  fi
done

echo -e "\nPorts restarted.\n"



# Check if the Integration server is up

# Start Integration Environment
start_time=$(date +%s)

echo "Starting Integration Environment ($INTEGRATION_URL)..."
cd environments/integration 
gnome-terminal --tab --title="Integration Server" -- bash -c "vagrant up && vagrant ssh; exec bash"
#check_service "$INTEGRATION_URL"

sleep 1800 # wait 30min

end_time=$(date +%s)
duration_seconds=$((end_time - start_time))
duration=$(echo "scale=2; $duration_seconds / 60" | bc)

# Display time taken
echo -e "Integration took $duration minutes.\n"


# Start Development Environment
echo "Starting Development Environment..."
cd ../dev
gnome-terminal --tab --title="Development" -- bash -c "vagrant up dev-frontend && vagrant ssh; exec bash"

#check_service $FRONTEND_IP $FRONTEND_PORT

# Start Staging Environment
#echo "Starting Staging Environment..."
#vagrant up staging
#check_service $STAGING_IP $STAGING_PORT

# Start Production Environment
#echo "Starting Production Environment..."
#vagrant up production
#check_service $PRODUCTION_IP $PRODUCTION_PORT

echo "All environments are up and running!"
