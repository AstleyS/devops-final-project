#!/bin/bash

# Start timer
start_time=$(date +%s)

# Closing all running Vagrant virtual machines
echo "Closing all running Vagrant virtual machines"
sleep 5
vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

# Restarting Ports
start_port=8080
end_port=8088

echo "Restarting ports:"

for port in $(seq $start_port $end_port); do
    # Check if the port is in use and kill the process
    if lsof -i :$port > /dev/null; then
        echo "Port $port is in use. Restarting..."
        fuser -k $port/tcp
        sleep 3
    else
        echo "Port $port is not in use."
    fi
done

echo "Ports restarted."

# Checking for dependencies
echo "Checking for dependencies"
current_version=$(ansible --version | awk -F '[[:space:]]+' '/ansible/ {print $2; exit}')
if [ -z "$current_version" ]; then
  echo "Ansible is not installed. Installing Ansible..."
  sudo apt-get update
  sudo apt-get install -y ansible
else
  echo "Ansible version $current_version is installed."
fi


#Initialising CI server			--------------------------------------------
echo "============Initialising CI server============"
cd integration-env

# Check if the VM is already created
if vagrant status | grep -q "not created"; then
    echo "The VM does not exist. Creating and provisioning the VM..."
    vagrant up
else
    echo "The VM exists. Halting, starting, and provisioning the VM..."
    vagrant halt -f && vagrant up && vagrant provision
fi

# Wait for the VM to be up
sleep 10


# Check if URL is up
url="http://192.168.56.5/gitlab"
status_code=$(curl --write-out %{http_code} --silent --output /dev/null "$url")
echo "Checking URL $url..."
while [[ "$status_code" -ne 200 ]]; do
echo "Waiting for $url to be up..."
sleep 10
status_code=$(curl --write-out %{http_code} --silent --output /dev/null "$url")
done
echo "$url is up and returned status code $status_code"


# Initializing Developer Environment
#echo "Initializing Developer Environment"
#cd dev-env
#vagrant halt-f && vagrant up

# Wait for the script to finish
#wait

# End timer
end_time=$(date +%s)
duration_seconds=$((end_time - start_time))
duration=$(echo "scale=2; $duration_seconds / 60" | bc)

# Display time taken
echo "Environment setup took $duration minutes."




vagrant ssh

# Exit script
exit 0
