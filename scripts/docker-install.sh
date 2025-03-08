#!/bin/bash
# Script to install Docker Engine on Debian/Ubuntu based systems (assuming root user - sudo su)

echo "Updating package lists..."
apt update

echo "Installing prerequisites..."
apt-get install -y ca-certificates curl gnupg

echo "Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up the Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package lists again to include Docker repository..."
apt update

echo "Installing Docker Engine, CLI, containerd, plugins..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker Engine installed successfully."

echo "Verifying Docker installation by running hello-world container..."
docker run hello-world

if [ $? -eq 0 ]; then
  echo "Docker verification successful: hello-world container ran without errors."
else
  echo "Warning: Docker verification with hello-world failed. Check for errors above."
fi

echo "Installation of Docker Engine complete."
