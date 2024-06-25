CI
The objective of this stage is to configure the GitLab project such that every time a developer publishes a change on the remote repository, the build process is automatically started. More precisely, upon detection of a change on the remote repository, GitLab has to:

image: Specifies the base Docker image for the CI jobs. Adjust the image based on the requirements of your project. You might want to use a custom image or a multi-stage build if your project has specific dependencies.

stages: Defines the stages of the pipeline.

cache: Caches dependencies to speed up subsequent builds.

variables: Defines variables to be used in the CI pipeline. GRADLE_USER_HOME is set for Gradle to cache dependencies, and NODE_ENV is set to production for the frontend build.

build_backend: Builds the backend application using Gradle. The artifacts section ensures that the build output is available for subsequent stages.

build_frontend: Builds the frontend application using npm.

test_backend: Runs tests for the backend application. Test reports are stored as artifacts and can be viewed in GitLab.

test_frontend: Runs tests for the frontend application.

run_backend: Starts the backend application.

run_frontend: Starts the frontend application.