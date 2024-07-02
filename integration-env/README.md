# Integration Server
The objective of this stage is to configure the GitLab project such that every time a developer publishes a change on the remote repository, the build process is automatically started. This setup is crucial for ensuring continuous integration, which helps maintain the stability and quality of the codebase. Here’s a more detailed overview of what needs to be accomplished:
    1. Check out/update source code
    Configure GitLab to automatically trigger a pipeline whenever a change (commit or merge request) is detected in the remote repository. This ensures that every change is immediately subject to validation. <br>
    2. Run the automated build script
    The pipeline in .gitlab-ci.yml file will run the automated build script. This script will include various build instructions (e.g., compiling code, running tests, deploy).
    3. Store the binaries where they can be accessed by the team.
    Store the build outputs (binaries) from our CI/CD pipeline.


Things to automate:
- Connection to gitlab
- Creation of a user
- Upload the project to gitlab 