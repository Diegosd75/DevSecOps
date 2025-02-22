FROM python:3.9

# 🔴 Variables de entorno con credenciales expuestas
ENV DB_USER="admin"
ENV DB_PASS="password123"
ENV SECRET_KEY="super_secret_key"

WORKDIR /app

COPY main.py /app

RUN pip install flask

CMD ["python", "main.py"]
