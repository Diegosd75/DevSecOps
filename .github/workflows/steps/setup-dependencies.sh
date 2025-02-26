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

wget https://github.com/jeremylong/DependencyCheck/releases/download/v8.4.0/dependency-check-8.4.0-release.zip
unzip dependency-check-8.4.0-release.zip
sudo mv dependency-check /usr/local/bin/
/usr/local/bin/dependency-check/bin/dependency-check.sh --version

echo "checkov, Dependency check, Bearer y Trivy funcionando correctamente."

# Crear directorio de resultados
mkdir -p results

# Construir la imagen Docker antes de escanear
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
cd "$REPO_ROOT" || { echo "Error: No se pudo acceder a la raíz del repositorio."; exit 1; }
IMAGE_NAME="$1"
echo "Construyendo la imagen Docker: $IMAGE_NAME en $REPO_ROOT"
docker build -t "$IMAGE_NAME" "$REPO_ROOT"
if [ $? -ne 0 ]; then
  echo "Error: Falló la construcción de la imagen Docker."
  exit 1
fi