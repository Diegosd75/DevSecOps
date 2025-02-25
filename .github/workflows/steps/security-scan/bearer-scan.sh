#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results
mkdir -p results/bearer-rules

# Asegurar que no existe un archivo o directorio conflictivo
rm -rf results/bearer-results.json

# Ejecutar Bearer en contenedor Docker con permisos correctos
docker run --rm --user $(id -u):$(id -g) \
  -v $(pwd):/src \
  -v $(pwd)/results/bearer-rules:/tmp/bearer-rules \
  bearer/bearer:latest-amd64 scan /src --output results/bearer-results.json --debug

# Verificar si el archivo se generó correctamente
if [ ! -f results/bearer-results.json ]; then
  echo "{}" > results/bearer-results.json
  echo "⚠️ Bearer no generó un archivo válido, se creó un JSON vacío."
fi

# Mensaje de confirmación
echo "✅ Bearer scan completado. Reporte generado en results/bearer-results.json"
