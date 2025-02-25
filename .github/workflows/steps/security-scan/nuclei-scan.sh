#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Ejecutar Nuclei dentro de un contenedor Docker con salida JSON
docker run --rm -v $(pwd)/results:/tmp projectdiscovery/nuclei:latest \
  -u https://example.com \
  -o /tmp/nuclei-results.json \
  -jsonl -debug

# Verificar si el archivo se generó correctamente
if [ ! -f results/nuclei-results.json ] || ! jq empty results/nuclei-results.json 2>/dev/null; then
  echo "{}" > results/nuclei-results.json
  echo "⚠️ Nuclei no generó un archivo válido, se creó un JSON vacío."
fi

# Mostrar contenido del archivo JSON para depuración
echo "🔍 Contenido de results/nuclei-results.json:"
cat results/nuclei-results.json | jq .

# Mensaje de confirmación
echo "✅ Nuclei scan completado. Reporte generado en results/nuclei-results.json"
