# What is Devops


**TLDR;**
Devops is all about people, process and tools for the benefit of business stability. 

# Definition
DevOps practices arose to bridge the gap between **development** (application, code, ...) and **operation** (deployment and maintenance of the application in production), avoiding issues when the code that worked in a developer's local environment failed in production due to environment differences, untested integrations, or lack of oversight on deployment consistency.

Devops introduced a new way to automate and streamline these processes, with a stronger focus oon collaboration, continuous testing and deployment. 
This makes it possible for teams to deliver reliable software more quickly and consistently. To support this we follow a pipeline.

## Devops Pipeline
A DevOps pipeline usually includes multiple environments that represent different stages in the lifecycle of a code, each with specific goals and requirements:


### Development Environment
In this environment developers code, test new features and fix bugs. It's isolated from other environments, so changes here don't affect the live product.

### Integration Environment
In this environment we combine separate parts of the applications and test as a whole.
Crucial for catching any issues that arise from how different components work together.

### Staging Environment
In this environment we mirror the production environment as closely as possible.
It's the final testing ground before deployment, where stakeholders can review new features, and last-minute testing can be done. Test performance, security and overall functionality ensure that the release will go smoothly in production

### Production Environment
This is the live environment where end users interact with the application. Stability, reliability and security are the top priorities here.
Deployments to production often done with utmost care.


# Project Objectives
**Objective:  Design a CI/CD pipeline to automate build, testing, deployment and release processes for a web application (e4l) while ensuring code reliability, speed and consistency with minimal human intervention** 

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


# Project Structure
```
project/
├── Vagrantfile
├── data/
│   ├── e4l/
│   ├── integration/
│   ├── staging/
│   └── production/
├── scripts/
│   ├── ansible/
│   │   ├── backend_setup.yml
│   │   ├── frontend_setup.yml
│   │   ├── integration_setup.yml
│   │   ├── staging_setup.yml
│   │   └── production_setup.yml
│   └── utilities/
└── README.md

```

# Resource Allocation Table

**Note:** The project is adapted to be able to run on 16GB run and 8 CPUs. (Depending on your computing resources) All VMs should not be all running simultaneously.   

| **VM Name**     | **Purpose**           | **RAM (GB)** | **CPUs** |
|-----------------|-----------------------|--------------|----------|
| Backend         | Runs backend services | 4 GB         | 2        |
| Frontend        | Hosts frontend app    | 4 GB         | 2        |
| Integration     | GitLab CI/CD server   | 5 GB         | 4        |
| Staging         | Near-production test  | 4 GB         | 2        |
| Production      | Final deployment      | 4 GB         | 2        |
| **Total Used**  |                       | **21 GB**    | **10**   |



# Other Notes 

integration server takes around 20min to vagrant up

git config --global user.name "User"
git config --global user.email "user@example.com"

cd existing_folder
git init --initial-branch=main
git remote add origin http://192.168.56.12/gitlab/user/e4l-frontend.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin main

export GITLAB_PROJECT_TOKEN="your_token_here"
