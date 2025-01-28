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


## Overview

### 1. Development Environment
1. Code changes are pushed to a VCS (Gitlab)
2. Gitlab CI/CD automatically detects the push and triggers the pipeline
3. Code moves to the **Integration Environment**
---
1. We have a single Vagrantfile that defines two boxes: frontend and backend
2. We have provisioning scripts (using the shell and Ansible) to automate the installation of necessary dependencies and frameworks for both ends

- The developer(s) write and test code locally, commit and push to the remote Gitlab repository

### 2. Integration Environment
1. Automate build scripts package the candidate (application)
2. Automate unit tests validate individual code components
3. If it passes, proceed to the **Staging Environment** 

### Staging Environment
1. Automated integrations tests verify that all application components work together
2. Automated user acceptance test (UAT) simulate user workflows to validate application functionality
3. If it passes, the product to **Production**

### Production Environment
1. The approved code is released automatically


## Steps

### 1. Development Environment
1. We have a single Vagrantfile that defines two boxes: frontend and backend
2. We have provisioning scripts (using the shell and Ansible) to automate the installation of necessary dependencies and frameworks for both ends

- The developer(s) write and test code locally, commit and push to the remote Gitlab repository

### 2. Integration Environment
1.  Gitlab detects the code push and triggers the pipeline defined in .gitlab-ci.yml
2. The pipeline executes:
    - Automated build scripts to package the application 
    - Automated unit tests to validate individual components 
3. If unit tests pass, the build artifacts (Docker images) are stored for deployment.


### Staging Environment
1. Retrieve the built artifact 
2. Mirror same setup to Production
3. Run integration tests to verify how components work together.
4. Run user acceptance tests (UAT) to simulate user workflows.
5. If UAT results approved, changes are released in Production

### Production Environment

