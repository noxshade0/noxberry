#!/bin/bash

# Exit on any error
set -e

echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing essential tools..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip python3-venv

echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

echo "Installing Docker..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Installing nginx..."
sudo apt install -y nginx

echo "Installing CasaOS..."
curl -fsSL https://get.casaos.io | sudo bash

echo "Cleaning up..."
sudo apt autoremove -y

echo "Installation complete! The system will reboot now..."

# Wait a few seconds before rebooting
sleep 5
sudo reboot
