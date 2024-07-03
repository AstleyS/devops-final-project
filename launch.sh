#!/bin/bash

# Start timer
start_time=$(date +%s)

# Closing all running Vagrant virtual machines
echo -e "\nClosing all running Vagrant virtual machines\n"
sleep 5
vagrant global-status --prune | awk '/virtualbox.*running/ {print $1}' | xargs -L1 vagrant halt

# Restarting Ports
start_port=8080
end_port=8088

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

# Checking for dependencies
echo -e "\nChecking for dependencies\n"
current_version=$(ansible --version | awk -F '[[:space:]]+' '/ansible/ {print $2; exit}')
if [ -z "$current_version" ]; then
  echo "Ansible is not installed. Installing Ansible..."
  sudo apt-get update
  sudo apt-get install -y ansible
else
  echo "Ansible version $current_version is installed."
fi


# Initialising CI server
echo -e "\n============Initialising CI server============\n"
cd integration-env

# Check if the VM is already created
if vagrant status | grep -q "not created"; then
    echo "The VM does not exist. Creating and provisioning the VM..."
    vagrant up
else
    echo "The VM exists. Halting, starting, and provisioning the VM..."
    vagrant halt -f
    vagrant up
    vagrant provision
    
sleep 10
fi

# Wait for the VM to be up and gitlab url to be connected
echo "Waiting for the VM to be up and gitlab url to be connected"
sleep 60


# Initializing Developer Environment
#echo "Initializing Developer Environment"
#cd dev-env
#vagrant halt-f && vagrant up

# Wait for the script to finish
#wait

echo -e "\n============CI server initialised============\n"

# End timer
end_time=$(date +%s)
duration_seconds=$((end_time - start_time))
duration=$(echo "scale=2; $duration_seconds / 60" | bc)

# Display time taken
echo -e "Environment setup took $duration minutes.\n"
sleep 5

vagrant ssh

# Exit script
exit 0
