#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Verificar si Trivy está instalado
echo "🔍 Verificando instalación de Trivy..."
if ! command -v trivy &> /dev/null; then
  echo "❌ Error: Trivy no está instalado. Ejecuta setup-dependencies.sh primero."
  exit 1
fi

# Verificar que Docker está en ejecución
if ! systemctl is-active --quiet docker; then
  echo "❌ Error: Docker no está en ejecución. Inícialo con 'sudo systemctl start docker'"
  exit 1
fi

# Encontrar la raíz del repositorio
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
cd "$REPO_ROOT" || { echo "❌ Error: No se pudo acceder a la raíz del repositorio."; exit 1; }

# Verificar si existe un Dockerfile en la raíz del repositorio
if [ ! -f "$REPO_ROOT/Dockerfile" ]; then
  echo "❌ Error: No se encontró un Dockerfile en la raíz del repositorio."
  exit 1
fi

# Construir la imagen Docker antes de escanear
IMAGE_NAME="custom-app:latest"
echo "🐳 Construyendo la imagen Docker: $IMAGE_NAME en $REPO_ROOT"
docker build -t "$IMAGE_NAME" "$REPO_ROOT"
if [ $? -ne 0 ]; then
  echo "❌ Error: Falló la construcción de la imagen Docker."
  exit 1
fi

# Asegurar que no existe un archivo conflictivo
rm -rf results/trivy-results.json

# Ejecutar Trivy directamente en la imagen recién construida
echo "🔍 Escaneando la imagen con Trivy..."
trivy image --format json -o results/trivy-results.json "$IMAGE_NAME"

# Verificar si el archivo se generó correctamente
if [ ! -f results/trivy-results.json ]; then
  echo "{}" > results/trivy-results.json
  echo "⚠️ Trivy no generó un archivo válido, se creó un JSON vacío."
fi

# Mensaje de confirmación
echo "✅ Trivy scan completado. Reporte generado en results/trivy-results.json"
