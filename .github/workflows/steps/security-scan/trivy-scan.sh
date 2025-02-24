#!/bin/bash

# Construir imagen Docker
docker build -t vulnerable-image:latest .

# Ejecutar Trivy para analizar la imagen Docker
trivy image --format json --output results/trivy-results.json vulnerable-image:latest || true
