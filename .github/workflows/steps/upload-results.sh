#!/bin/bash

#Capturar variables
DEFECTDOJO_API_KEY="$1"
ENGAGEMENT_NAME="$2"
PRODUCT_NAME="$3"
DEFECTDOJO_URL="$4"



# Verificar si el producto existe
PRODUCT_RESPONSE=$(curl -s -X GET "$DEFECTDOJO_URL/products/" -H "Authorization: Token $DEFECTDOJO_API_KEY")
if [[ "$PRODUCT_RESPONSE" != *"$PRODUCT_NAME"* ]]; then
  echo "Error: El producto '$PRODUCT_NAME' no existe en DefectDojo."
  exit 1
fi

# Verificar si el engagement existe
ENGAGEMENT_RESPONSE=$(curl -s -X GET "$DEFECTDOJO_URL/engagements/" -H "Authorization: Token $DEFECTDOJO_API_KEY")
if [[ "$ENGAGEMENT_RESPONSE" != *"$ENGAGEMENT_NAME"* ]]; then
  echo "Error: El engagement '$ENGAGEMENT_NAME' no existe en DefectDojo."
  exit 1
fi

# Definir Scan Types para la subida de archivos
declare -A SCAN_TYPES
SCAN_TYPES=(
  [nuclei-results.json]="Nuclei Scan"
  [gitleaks-report.json]="Gitleaks Scan"
  [bearer-results.json]="Bearer CLI"
  [trivy-results.json]="Trivy Scan"
  [dependency-check-report.xml]="Dependency Check Scan"
  [checkov-results.json]="Checkov Scan"
)

# Subir los resultados de los escaneos 
for file in "${!SCAN_TYPES[@]}"; do
  if [ -f "results/$file" ]; then

    # Verificar si el archivo está vacío
    if [ ! -s "results/$file" ]; then
      echo "Archivo $file está vacío. Omitiendo subida."
      continue
    fi
    
    scan_type="${SCAN_TYPES[$file]}"
    echo "Uploading $file as $scan_type"
    response=$(curl -s -X POST "$DEFECTDOJO_URL/import-scan/" \
      -H "Authorization: Token $DEFECTDOJO_API_KEY" \
      -H "Content-Type: multipart/form-data" \
      -F "scan_type=$scan_type" \
      -F "product_name=$PRODUCT_NAME" \
      -F "engagement_name=$ENGAGEMENT_NAME" \
      -F "file=@results/$file" -v)
    if [[ "$response" == *"error"* || -z "$response" ]]; then
      echo "Error al subir $file a DefectDojo."
      exit 1
    fi
  else
    echo "Archivo $file no encontrado. Omitiendo..."
  fi
done

echo "Todos los archivos de escaneo fueron procesados correctamente."
