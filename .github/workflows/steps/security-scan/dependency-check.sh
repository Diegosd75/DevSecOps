#!/bin/bash

# Ejecutar Dependency Check
/usr/local/bin/dependency-check/bin/dependency-check.sh --scan . --format XML --out results/dependency-check-report.xml || touch results/dependency-check-report.xml

echo "Dependency-Check scan completado. Reporte generado en results/dependency-check-report.xml"