#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Ejecutar Nuclei dentro de un contenedor Docker
docker run --rm -v $(pwd):/tmp projectdiscovery/nuclei:latest -u https://example.com -o /tmp/results/nuclei-results.txt 

# Mensaje de confirmación
echo "Nuclei scan completado. Reporte generado en results/nuclei-results.txt"
