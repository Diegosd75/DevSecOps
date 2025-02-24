#!/bin/bash

# Ejecutar Checkov para analizar infraestructura como código
checkov --directory . --output json --output-file results/checkov-results.json || true
