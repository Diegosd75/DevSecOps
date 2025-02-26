#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Asegurar que el archivo JSON existe antes de ejecutar Checkov
touch results/checkov-results.json

# Asegurar que no existe un archivo o directorio conflictivo
if [ -d "results/checkov-results.json" ]; then
  echo "⚠️ Eliminando directorio incorrecto en lugar de archivo JSON..."
  rm -rf results/checkov-results.json
fi

# Ejecutar Checkov y capturar salida
echo "🔍 Ejecutando Checkov..."
checkov --directory . --output json > results/checkov-results.json 2> results/checkov-log.txt

# Verificar si el archivo JSON se generó correctamente
if [ ! -s results/checkov-results.json ] || ! jq empty results/checkov-results.json 2>/dev/null; then
  echo "⚠️ Checkov no generó un archivo válido, creando un JSON vacío."
  echo '{}' > results/checkov-results.json
  echo "🔍 Registro de errores de Checkov:"
  cat results/checkov-log.txt
else
  echo "✅ Archivo JSON de Checkov generado correctamente."
fi


# Mensaje de confirmación
echo "✅ Checkov scan completado. Reporte disponible en results/checkov-results.json"
