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


# Project Overview

This repository contains an automation project that sets up a CI/CD pipeline with integration, development, and production environments. The goal is to automate environment setup, application deployment, and running GitLab CI/CD pipelines to build, test, and deploy the project.

---

## Project Structure

The project is organized as follows:

```bash
/project-root
│── data
│── Dockerfile
│── environments
│   ├── dev
│   │   ├── Vagrantfile
│   │   ├── dev.yml
│   │   └── playbook
│   │       ├── roles
│   │       │   └── (role directories and files)
│   ├── integration
│   │   └── (integration-related files)
│   └── production
│       └── (production-related files)
│── launch.sh
│── Notes.md
│── README.md
│── scenarios.txt
```

- `data/`: Contains shared data like configuration files and artifacts.
- `Dockerfile`: A Dockerfile for building the application container image.
- `environments/`: Contains the setup for different environments:
  - `dev/`: Development environment setup including Vagrantfile, playbook, and roles for automation.
  - `integration/`: Integration environment setup files.
  - `production/`: Production environment setup files.
- `launch.sh`: A script to initiate the environments, set up the CI/CD server, and trigger the processes for the pipeline.
- `Notes.md`: Additional notes or information related to the project.
- `README.md`: This file, which gives an overview of the project.
- `readme.txt`: Describes how to use all the previous items to setup the Deployment Pipeline.
- `scenarios.txt`: Describes the scenarios for user actions and automation steps in the pipeline.

---

## Launch Process

`launch.sh` automates the entire process from environment setup to project deployment. Below is the step-by-step workflow:

### **1. Initiate the Integration Environment:**

The first step is to start the integration environment, which involves setting up the CI/CD server and configuring the GitLab Runner. The `RUNNER_TOKEN` must be provided manually. The script does the following:
  - Starts the integration environment.
  - Registers the GitLab Runner with the appropriate token.
  - Configures the necessary services for CI/CD.
  - Initializes the project repository.


### **3. Production Environment Setup:**

After the integration environment is set up, the script proceeds to the production environment. Ideally, it must be deployed to the staging environment where the artifact/candidate is submitted to tests before releasing into production. This step performs the following actions:
  - Start the production environments
  - Waits for the artifact to be released from the previous stage/environment

### **3. Dev Environment Setup:**

After the integration and production environment are set up, the script proceeds to the development environment. This step performs the following actions:
  - Clones the project repository.
  - Configures Git for `user1`.
  - Makes changes to the project (e.g., modifies the README file).
  - Commits the changes.
  - Pushes the changes to GitLab, triggering the CI/CD pipeline.

The pipeline will automatically run, performing tests and validations as specified in the `.gitlab-ci.yml` file.

### **3. Pipeline Execution:**

Once changes are committed, the GitLab Runner will execute the pipeline as defined in the `.gitlab-ci.yml`. The stages include:
  - **Install**: Install project dependencies.
  - **Test**: Run tests on the application.
  - **Run**: Deploy the application or build artifacts.

Artifacts produced by the pipeline are saved for deployment.

### **4. Release to Production:**

Upon successful execution of the pipeline, the project is released to the production environment. The release involves:
  - Saving the build artifacts.
  - Deploying the application to production environment.

### **Manual Steps:**
- The `RUNNER_TOKEN` must be provided manually. It is expected to be placed in `/vagrant_data/shared/runner_access_token.txt`. This value is displayed and can be retrieved from the terminal, otherwise you must retrieve it from Gitlab. 

- It might be necessary to enter into the developer's environment to proceed with the clone the repo, commit and push the changes. 

---

## How to Use `launch.sh`

To start the setup process, simply run the `launch.sh` script from the root of the project. The script will:
1. Set up the integration environment.
2. Configure and start the development environment.
3. Trigger the pipeline.
4. Deploy the project to production.

In the terminal:
```bash
./launch.sh
```