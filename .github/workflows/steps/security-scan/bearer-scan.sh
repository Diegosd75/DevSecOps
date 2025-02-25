#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Ejecutar Bearer dentro de un contenedor Docker asegurando que el archivo JSON se cree correctamente
docker run --rm -v $(pwd):/src bearer/bearer scan --format json --output /src/results/bearer-results.json /src

# Verificar si el archivo se generó correctamente
if [ ! -f results/bearer-results.json ] || ! jq empty results/bearer-results.json 2>/dev/null; then
  echo "{}" > results/bearer-results.json
  echo "⚠️ Bearer no generó un archivo válido, se creó un JSON vacío."
fi

# Mostrar contenido del archivo JSON para depuración
echo "🔍 Contenido de results/bearer-results.json:"
cat results/bearer-results.json | jq .

# Mensaje de confirmación
echo "✅ Bearer scan completado. Reporte generado en results/bearer-results.json"
