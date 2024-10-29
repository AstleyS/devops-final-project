# Use an Ubuntu base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update -y && \
    apt-get install -y curl software-properties-common apt-transport-https ca-certificates gnupg-agent python3 make wget unzip && \
    apt-get clean

############## FRONTEND ##############

# Install nvm and Node.js 15.14.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    bash -c "source ~/.nvm/nvm.sh && nvm install 15.14.0 && nvm use 15.14.0 && nvm alias default 15.14.0" 

# Install npm 7.7.6
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g npm@7.7.6"

############## BACKEND ############## 

# Install default-jre
RUN apt-get install -y default-jre

# Install OpenJDK 19
RUN apt-get install -y openjdk-19-jdk

# Install Gradle 8.3
RUN wget https://services.gradle.org/distributions/gradle-8.3-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-8.3-bin.zip && \
    rm gradle-8.3-bin.zip

# Set PATH for Gradle
ENV PATH="$PATH:/opt/gradle/gradle-8.3/bin"

# Install MySQL server
RUN echo "mysql-server mysql-server/root_password password 12345678" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password 12345678" | debconf-set-selections && \
    apt-get install -y mysql-server && \
    service mysql start && \
    service mysql enable

# Expose MySQL port
EXPOSE 3306

CMD ["bash"]
