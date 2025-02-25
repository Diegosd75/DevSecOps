#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Asegurar que no existe un archivo o directorio conflictivo
if [ -d "results/checkov-results.json" ]; then
  echo "⚠️ Eliminando directorio incorrecto en lugar de archivo JSON..."
  rm -rf results/checkov-results.json
fi

# Ejecutar Checkov y capturar salida
checkov --directory . --output json --output-file results/checkov-results.json > results/checkov-log.txt 2>&1

# Verificar si el archivo JSON se generó correctamente
if [ ! -f results/checkov-results.json ] || ! jq empty results/checkov-results.json 2>/dev/null; then
  echo "{}" > results/checkov-results.json
  echo "⚠️ Checkov no generó un archivo válido, se creó un JSON vacío."
  echo "🔍 Registro de errores de Checkov:"
  cat results/checkov-log.txt
fi

# Comprimir el archivo JSON si es muy grande
if [ -f results/checkov-results.json ]; then
  JSON_SIZE=$(stat -c%s "results/checkov-results.json")
  MAX_SIZE=$((50 * 1024 * 1024)) # 50MB
  if [ "$JSON_SIZE" -gt "$MAX_SIZE" ]; then
    echo "🔄 Comprimendo checkov-results.json..."
    gzip -f results/checkov-results.json
    echo "✅ Archivo comprimido: results/checkov-results.json.gz"
  fi
fi

# Mensaje de confirmación
echo "✅ Checkov scan completado. Reporte generado en results/checkov-results.json"
