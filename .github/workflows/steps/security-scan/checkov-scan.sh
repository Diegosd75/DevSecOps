#!/bin/bash

touch results/checkov-results.json

# Ejecutar Checkov y capturar salida
echo "Ejecutando Checkov..."
checkov --directory . --output json > results/checkov-results.json 2> results/checkov-log.txt


echo "Checkov scan completado. Reporte disponible en results/checkov-results.json"