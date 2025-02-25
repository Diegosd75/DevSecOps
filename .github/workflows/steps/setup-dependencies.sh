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

# Instalar Trivy
echo "🔍 Verificando instalación de Trivy..."
if ! command -v trivy &> /dev/null; then
  echo "⚠️ Trivy no encontrado. Instalando..."
  sudo apt-get install -y wget
  wget -O trivy.tar.gz https://github.com/aquasecurity/trivy/releases/latest/download/trivy_Linux-64bit.tar.gz
  if [ $? -ne 0 ]; then
    echo "❌ Error: No se pudo descargar Trivy. Verificando URL..."
    exit 1
  fi
  tar zxvf trivy.tar.gz
  sudo mv trivy /usr/local/bin/
  rm -f trivy.tar.gz
  export PATH=$PATH:/usr/local/bin
  echo "✅ Trivy instalado correctamente."
fi

# Verificar instalaciones
checkov --version
docker run --rm bearer/bearer:latest-amd64 --version || echo "Error ejecutando Bearer con Docker"
trivy --version || echo "Error ejecutando Trivy"
