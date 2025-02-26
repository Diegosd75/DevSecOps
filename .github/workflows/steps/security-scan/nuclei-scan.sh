#!/bin/bash

# Ejecutar Nuclei dentro de un contenedor Docker con salida JSON
docker run --rm -v $(pwd)/results:/tmp projectdiscovery/nuclei:latest \
  -u https://example.com \
  -o /tmp/nuclei-results.json \
  -jsonl -debug

echo "Nuclei scan completado. Reporte generado en results/nuclei-results.json"