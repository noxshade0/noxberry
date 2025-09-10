#!/bin/bash

set -e

echo "Detecting OS..."

OS_ID=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d \")
OS_VERSION_CODENAME=$(grep ^VERSION_CODENAME= /etc/os-release | cut -d= -f2)

echo "OS detected: $OS_ID"
echo "Codename: $OS_VERSION_CODENAME"

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

sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings

if [[ "$OS_ID" == "raspbian" || "$OS_ID" == "debian" ]]; then
    echo "Detected Raspberry Pi OS / Debian"
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $OS_VERSION_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [[ "$OS_ID" == "ubuntu" ]]; then
    echo "Detected Ubuntu"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $OS_VERSION_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
else
    echo "OS not recognized, aborting Docker install"
    exit 1
fi

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

sleep 5
sudo reboot
