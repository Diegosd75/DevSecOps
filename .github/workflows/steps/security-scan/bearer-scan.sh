#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Ejecutar Bearer dentro de un contenedor Docker
docker run --rm -v $(pwd):/tmp bearer/bearer:latest-amd64 scan /tmp --output results/bearer-results.json 

# Mensaje de confirmación
echo "Bearer scan completado. Reporte generado en results/bearer-results.json"
