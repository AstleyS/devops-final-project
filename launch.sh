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
    if sudo lsof -i :$port > /dev/null; then
        echo "Port $port is in use. Restarting..."
        sudo fuser -k $port/tcp
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
echo "Initialising CI server"
cd integration-env

# Check if the VM is already created
if vagrant status | grep -q "not created"; then
    echo "The VM does not exist. Creating and provisioning the VM..."
    vagrant up
else
    echo "The VM exists. Halting, starting, and provisioning the VM..."
    vagrant halt -f && vagrant up && vagrant provision
fi

#Product_url="http://192.168.58.111/gitlab/users/sign_in"
#http_status=""

#echo "Waiting for the CI server to start..."


# Initializing Developer Environment
#echo "Initializing Developer Environment"
#cd dev-env
#vagrant halt-f && vagrant up

# Wait for the script to finish
#wait

# End timer
end_time=$(date +%s)
duration=$(echo "scale=2; $duration_seconds / 60" | bc)

# Display time taken
echo "Development environment setup took $duration minutes."

vagrant ssh

# Exit script
exit 0
