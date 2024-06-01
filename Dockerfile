# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    vim \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    openssh-server \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create a new user with sudo privileges
RUN useradd -ms /bin/bash render && echo 'render:render' | chpasswd && adduser render sudo

# Set the working directory
WORKDIR /home/render

# Expose the desired port (for example, 22 for SSH)
EXPOSE 22

# Install and configure OpenSSH server
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]

# Additional commands to keep the container running and prevent it from exiting
CMD ["tail", "-f", "/dev/null"]
