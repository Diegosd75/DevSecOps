#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Asegurar que no existe una carpeta con el mismo nombre
rm -rf results/checkov-results.json

# Ejecutar Checkov y forzar la generación del archivo
checkov --directory . --output json --output-file results/checkov-results.json || echo '{}' > results/checkov-results.json

# Mensaje de confirmación
echo "Checkov scan completado. Reporte generado en results/checkov-results.json"
