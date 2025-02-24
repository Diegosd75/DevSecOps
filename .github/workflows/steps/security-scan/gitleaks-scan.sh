#!/bin/bash

# Crear directorio de resultados
mkdir -p results

# Ejecutar Gitleaks para detectar secretos en el código
docker run --rm -v $(pwd):/path zricethezav/gitleaks:latest detect --source=/path --verbose \
  --report-format=json --report-path=/path/results/gitleaks-report.json || true

echo "Gitleaks scan completado. Reporte generado en results/gitleaks-report.json"
