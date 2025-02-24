#!/bin/bash

# Verificar que el token API fue proporcionado
if [ -z "$1" ]; then
  echo "❌ Error: Token de DefectDojo no proporcionado."
  exit 1
fi
DEFECTDOJO_API_KEY="$1"

# Definir engagement_name y product_name
ENGAGEMENT_NAME="Automated Security Scan"
PRODUCT_NAME="Repositorio_DevSecOps"
DEFECTDOJO_URL="http://18.220.221.176:8080/api/v2"

# Verificar si el producto existe
PRODUCT_RESPONSE=$(curl -s -X GET "$DEFECTDOJO_URL/products/" -H "Authorization: Token $DEFECTDOJO_API_KEY")
if [[ "$PRODUCT_RESPONSE" != *"$PRODUCT_NAME"* ]]; then
  echo "❌ Error: El producto '$PRODUCT_NAME' no existe en DefectDojo."
  exit 1
fi

# Verificar si el engagement existe
ENGAGEMENT_RESPONSE=$(curl -s -X GET "$DEFECTDOJO_URL/engagements/" -H "Authorization: Token $DEFECTDOJO_API_KEY")
if [[ "$ENGAGEMENT_RESPONSE" != *"$ENGAGEMENT_NAME"* ]]; then
  echo "❌ Error: El engagement '$ENGAGEMENT_NAME' no existe en DefectDojo."
  exit 1
fi

# Subir los resultados de los escaneos a DefectDojo
for file in checkov-results.json nuclei-results.txt gitleaks-report.json trivy-results.json dependency-check-report.xml bearer-results.json; do
  if [ -f "results/$file" ]; then
    scan_type=$(echo "$file" | sed 's/-results.*//g' | sed 's/.json//g' | sed 's/.txt//g' | sed 's/.xml//g' | tr '-' ' ' | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
    echo "Uploading $file as $scan_type Scan"
    response=$(curl -s -X POST "$DEFECTDOJO_URL/import-scan/" \
      -H "Authorization: Token $DEFECTDOJO_API_KEY" \
      -H "Content-Type: multipart/form-data" \
      -F "scan_type=$scan_type Scan" \
      -F "product_name=$PRODUCT_NAME" \
      -F "engagement_name=$ENGAGEMENT_NAME" \
      -F "file=@results/$file" -v)
    echo "Response: $response"
    if [[ "$response" == *"error"* || -z "$response" ]]; then
      echo "❌ Error al subir $file a DefectDojo. Verifica que el engagement existe."
      exit 1
    fi
  else
    echo "⚠️ Archivo $file no encontrado. Omitiendo..."
  fi
done

echo "✅ Todos los archivos de escaneo fueron procesados correctamente."
