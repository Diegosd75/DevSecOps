#!/bin/bash

# Verificar que el token API fue proporcionado
if [ -z "$1" ]; then
  echo "❌ Error: Token de DefectDojo no proporcionado."
  exit 1
fi
DEFECTDOJO_API_KEY="$1"

# Subir los resultados de los escaneos a DefectDojo
for file in checkov-results.json nuclei-results.txt gitleaks-report.json trivy-results.json dependency-check-report.xml bearer-results.json; do
  if [ -f "results/$file" ]; then
    scan_type=$(echo "$file" | sed 's/-results.*//g' | sed 's/.json//g' | sed 's/.txt//g' | sed 's/.xml//g' | tr '-' ' ' | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
    echo "Uploading $file as $scan_type Scan"
    response=$(curl -X POST "http://18.220.221.176:8080/api/v2/import-scan/" \
      -H "Authorization: Token $DEFECTDOJO_API_KEY" \
      -H "Content-Type: multipart/form-data" \
      -F "scan_type=$scan_type Scan" \
      -F "product_name=DevSecOps" \
      -F "file=@results/$file")
    echo "Response: $response"
    if [[ "$response" == *"error"* ]]; then
      echo "❌ Error al subir $file a DefectDojo."
      exit 1
    fi
  else
    echo "⚠️ Archivo $file no encontrado. Omitiendo..."
  fi
done

echo "✅ Todos los archivos de escaneo fueron procesados correctamente."
