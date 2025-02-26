#!/bin/bash

# Encontrar la raíz del repositorio
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
cd "$REPO_ROOT" || { echo "Error: No se pudo acceder a la raíz del repositorio."; exit 1; }

# Construir la imagen Docker antes de escanear
IMAGE_NAME="custom-app:latest"
echo "Construyendo la imagen Docker: $IMAGE_NAME en $REPO_ROOT"
docker build -t "$IMAGE_NAME" "$REPO_ROOT"
if [ $? -ne 0 ]; then
  echo "Error: Falló la construcción de la imagen Docker."
  exit 1
fi

# Ejecutar Trivy directamente en la imagen recién construida
echo "Escaneando la imagen con Trivy..."
trivy image --format json -o results/trivy-results.json "$IMAGE_NAME"

echo "Trivy scan completado. Reporte generado en results/trivy-results.json"