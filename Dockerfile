# Usamos una imagen base vulnerable con múltiples CVEs
FROM python:3.6

# Exponemos variables de entorno sensibles (⚠️ Mala práctica)
ENV SECRET_KEY="SuperSecret123"
ENV DATABASE_URL="mysql://root:password@db"

# Instalamos paquetes innecesarios y potencialmente peligrosos (⚠️ Red flag para Trivy)
RUN apt-get update && apt-get install -y \
    curl \
    netcat \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Copiamos el código de la aplicación
WORKDIR /app
COPY main.py .

# Ejecutamos el servidor como root (⚠️ Mala práctica)
CMD ["python", "main.py"]
