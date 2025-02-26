#!/bin/bash

# Ejecutar Bearer dentro de un contenedor Docker asegurando que el archivo JSON se cree correctamente
docker run --rm -v $(pwd):/src bearer/bearer scan --format json --output /src/results/bearer-results.json /src

echo "Bearer scan completado. Reporte generado en results/bearer-results.json"