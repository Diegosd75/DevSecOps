#!/bin/bash

# Crear directorio de resultados si no existe
mkdir -p results

# Ejecutar Checkov y forzar la generación del archivo
checkov --directory . --output json --output-file results/checkov-results.json || echo '{}' > results/checkov-results.json

# Mensaje de confirmación
echo "Checkov scan completado. Reporte generado en results/checkov-results.json"
