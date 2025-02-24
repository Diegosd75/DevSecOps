#!/bin/bash

# Instalar dependencias del sistema
sudo apt-get update
sudo apt-get remove -y containerd.io docker.io || true
sudo apt-get install -y golang jq curl pre-commit git wget unzip python3 python3-pip nodejs npm

# Actualizar npm
npm install -g npm@latest

# Instalar Docker CE
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
echo "Docker instalado correctamente."

docker --version

# Instalar Checkov
pip3 install checkov

# Usar Docker para ejecutar Bearer
sudo docker pull bearer/bearer:latest-amd64

echo "Bearer instalado correctamente con Docker."

# Verificar instalaciones
checkov --version
docker run --rm bearer/bearer:latest-amd64 --version || echo "Error ejecutando Bearer con Docker"
