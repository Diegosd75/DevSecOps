#!/bin/bash

# Instalar Dependency Check
wget https://github.com/jeremylong/DependencyCheck/releases/download/v8.4.0/dependency-check-8.4.0-release.zip
unzip dependency-check-8.4.0-release.zip
sudo mv dependency-check /usr/local/bin/
/usr/local/bin/dependency-check/bin/dependency-check.sh --version

# Ejecutar Dependency Check
/usr/local/bin/dependency-check/bin/dependency-check.sh --scan . --format XML --out results/dependency-check-report.xml || touch results/dependency-check-report.xml
