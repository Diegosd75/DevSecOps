#!/bin/bash

# Ejecutar Trivy directamente en la imagen recién construida
echo "Escaneando la imagen con Trivy..."
trivy image --format json -o results/trivy-results.json "$IMAGE_NAME"

echo "Trivy scan completado. Reporte generado en results/trivy-results.json"