#!/bin/bash

# Instalar dependencias del sistema
sudo apt-get update
sudo apt-get remove -y containerd.io docker.io || true
sudo apt-get install -y golang jq curl pre-commit git wget unzip python3 python3-pip nodejs npm

npm install -g npm@latest

curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
echo "Docker instalado correctamente."


# Instalar servicios de escaneo 
pip3 install checkov

sudo docker pull bearer/bearer:latest-amd64

sudo apt-get install -y apt-transport-https gnupg lsb-release
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy-keyring.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy

echo "checkov, Bearer y Trivy funcionando correctamente."

# Crear directorio de resultados
mkdir -p results