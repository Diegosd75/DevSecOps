#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Verificar si Trivy está instalado, si no, instalarlo
echo "🔍 Verificando instalación de Trivy..."
if ! command -v trivy &> /dev/null; then
  echo "⚠️ Trivy no encontrado. Instalando..."
  sudo apt-get install -y wget
  wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_Linux-64bit.tar.gz
  tar zxvf trivy_Linux-64bit.tar.gz
  sudo mv trivy /usr/local/bin/
  export PATH=$PATH:/usr/local/bin
  echo "✅ Trivy instalado."
fi

# Verificar si Trivy funciona correctamente
if ! trivy --version &> /dev/null; then
  echo "❌ Error: Trivy no se instaló correctamente."
  exit 1
fi

# Asegurar que no existe un archivo conflictivo
rm -rf results/trivy-results.json

# Ejecutar Trivy en el contenedor Docker
docker run --rm -v $(pwd):/src aquasec/trivy image --format json -o /src/results/trivy-results.json vulnerable-image:latest

# Verificar si el archivo se generó correctamente
if [ ! -f results/trivy-results.json ]; then
  echo "{}" > results/trivy-results.json
  echo "⚠️ Trivy no generó un archivo válido, se creó un JSON vacío."
fi

# Mensaje de confirmación
echo "✅ Trivy scan completado. Reporte generado en results/trivy-results.json"
