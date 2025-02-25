#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Asegurar que no existe un archivo o directorio con el mismo nombre
rm -rf results/checkov-results.json

# Ejecutar Checkov
checkov --directory . --output json --output-file results/checkov-results.json

# Verificar si el archivo se generó correctamente
if [ ! -f results/checkov-results.json ]; then
  echo "{}" > results/checkov-results.json
  echo "⚠️ Checkov no generó un archivo, se creó un JSON vacío."
fi

# Comprimir el archivo JSON si es muy grande
JSON_SIZE=$(stat -c%s "results/checkov-results.json")
MAX_SIZE=$((50 * 1024 * 1024)) # 50MB
if [ "$JSON_SIZE" -gt "$MAX_SIZE" ]; then
  echo "🔄 Comprimendo checkov-results.json..."
  gzip -f results/checkov-results.json
  echo "✅ Archivo comprimido: results/checkov-results.json.gz"
fi

# Mensaje de confirmación
echo "✅ Checkov scan completado. Reporte generado en results/checkov-results.json"
