Software Engineering Environments (or DevOps) Final Project

## Prerequisites

### Hardware Requirements

1. Laptop with at least 8 Gb memory (recommended 16 Gb, ideally 32 Gb)

### Software Dependencies

- VirtualBox(v 6.0, or higher)
Instructions to install here: https://www.virtualbox.org/wiki/Downloads

- Vagrant (v 2.2.5, or higher)
Instructions to install here: https://www.vagrantup.com/downloads.html
(only if using Windows 10 or Windows 8 Pro) Disable Hyper-V, see instructions to disable here: https://www.poweronplatforms.com/enable-disable-hyper-v-windows-10-8/
Check installation with the command vagrant -v'

- Ansible (v 2.7.5, or higher)
Instructions to install here: https://docs.ansible.com/
Check installation with the command ansible --version


### Student
- Astley GOMES DOS SANTOS, 0211250012

### Running the Project
To execute the project, use the following Bash command:

```bash
./launch.sh
```

The `launch.sh` script automates the setup by performing the following steps:

1. **Turning Off Virtual Machines**: Ensures that any running Vagrant virtual machines are turned off.
2. **Restarting Ports**: Restarts ports 8080 to 8088, resolving potential conflicts with other programs.
