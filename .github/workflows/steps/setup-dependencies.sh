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

# Instalar Bearer
npm install -g @bearer/bearer-cli

# Asegurar que Bearer está en el PATH
export PATH=$(npm root -g)/.bin:$PATH

# Verificar instalaciones
checkov --version
which bearer
bearer --version
