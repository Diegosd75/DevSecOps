# Repositorio DevSecOps

Este repositorio está diseñado para integrar prácticas de seguridad dentro del ciclo de desarrollo y operaciones, fomentando una cultura de seguridad desde el inicio del proceso de desarrollo de software. Aquí encontrarás herramientas y scripts que permiten automatizar el análisis de seguridad en diferentes niveles del sistema, asegurando que las vulnerabilidades sean detectadas y corregidas lo antes posible. Y todo esto es enviado a una herramienta de Gestion llamada Defectdojo.

## Estructura del Repositorio

El repositorio está organizado de la siguiente manera:

```
DevSecOps/
│── .github/workflows/
│   ├── main-pipeline.yml
│   └── steps/
│       ├── setup-dependencies.sh
│       ├── upload-results.sh
│       └── security-scan/
│           └── bearer-scan.sh
│           ├── checkov-scan.sh
│           ├── dependency-check.sh
│           ├── gitleaks-scan.sh
│           ├── nuclei-scan.sh
│           ├── trivy-scan.sh
│── Dockerfile
│── main.py
│── README.md
```

### `.github/workflows/`
Contiene los flujos de trabajo de integración continua (CI/CD). En particular, `main-pipeline.yml` define los pasos necesarios para ejecutar análisis de seguridad automatizados durante el desarrollo. Dentro de esta estructura, se encuentra el subdirectorio `steps/security-scan/`, que almacena los scripts necesarios para ejecutar los análisis de seguridad.

### `stepsn/`
Esta carpeta contiene los scripts específicos que se utilizan en los flujos de trabajo y la carpeta que tiene los escaneos de seguridad `security-scan/`. A continuación los script que contiene:

- **`setup-dependencies.sh`**: Configuración inicial de herramientas necesarias para los escaneos de seguridad.
- **`upload-results.sh`**: Sube los resultados de los escaneos a la plataforma de monitoreo Defecdojo.

### `security-scan/`
Esta carpeta contiene los scripts específicos que se utilizan en los flujos de trabajo para ejecutar distintos escaneos de seguridad:

- **`bearer-scan.sh`**: Ejecuta un escaneo de código estático con Bearer, especializado en detectar datos sensibles y problemas de privacidad en el código fuente.
- **`checkov-scan.sh`**: Realiza un escaneo de infraestructura como código (IaC) con Checkov, asegurando configuraciones seguras en el Dockerfile.
- **`dependency-check.sh`**: Analiza las dependencias del proyecto para identificar vulnerabilidades conocidas en bibliotecas de terceros.
- **`gitleaks-scan.sh`**: Escanea repositorios en busca de credenciales y secretos expuestos en el código fuente.
- **`nuclei-scan.sh`**: Ejecuta pruebas de seguridad automatizadas con Nuclei mediante el uso de plantillas de vulnerabilidades predefinidas, en este caso analizando el dominio https://example.com.
- **`trivy-scan.sh`**: Analiza imágenes de contenedores y dependencias de código en busca de vulnerabilidades, garantizando la seguridad en entornos Docker y Kubernetes.

### `Dockerfile`
Se configura un contenedor para la ejecución de los análisis de seguridad sobre este mismo. Además, se define los comandos de entrada para que los análisis se ejecuten automáticamente. Con esta configuración, se garantiza una fuente de análisis, para que todos los test de seguridad se ejecuten de buena manera.

### `main.py`
Este archivo contiene una aplicación en Flask que expone una API con funcionalidades matemáticas básicas. Sin embargo, la implementación introduce varias vulnerabilidades de seguridad:

- **Inyección de comandos**: Permite la ejecución de comandos arbitrarios en el sistema mediante `subprocess.check_output`, lo que podría comprometer la integridad del servidor.
- **Deserialización insegura**: Usa `pickle.loads()` sin validar los datos de entrada, lo que puede permitir la ejecución de código malicioso.
- **Exposición de variables de entorno**: Proporciona acceso a variables del sistema, lo que puede filtrar información sensible como claves API o credenciales.

Tener en cuenta que este código sirve como un ejemplo práctico de riesgos de seguridad que deben ser gestionados en el contexto de DevSecOps.

## Herramientas de Seguridad

### Bearer (SAST)
Realiza un análisis estático del código fuente para detectar datos sensibles y problemas de privacidad. Se eligió por su capacidad de identificar filtraciones accidentales de información confidencial en repositorios de código, reduciendo riesgos de exposición de datos sensibles.

### Checkov (IaC)
Ejecuta un escaneo de infraestructura como código (IaC) para validar que las configuraciones en Docker y otras herramientas sean seguras y cumplan con buenas prácticas. Fue seleccionado por su eficacia en la detección de configuraciones inseguras y el cumplimiento de estándares de seguridad.

### Dependency-Check (SCA)
Realiza un análisis de seguridad en las dependencias del proyecto, verificando vulnerabilidades conocidas en bibliotecas de terceros. Se incluyó en el proceso porque permite identificar riesgos de seguridad derivados del uso de paquetes desactualizados o con fallas documentadas.

### Gitleaks (Secrets Scan)
Escanea el repositorio en busca de credenciales y secretos expuestos en el código fuente, ayudando a prevenir la filtración de claves API, contraseñas y otros datos sensibles. Su uso es clave para evitar errores humanos que puedan comprometer la seguridad del sistema.

### Nuclei (DAST)
Ejecuta pruebas de seguridad dinámicas basadas en plantillas predefinidas para evaluar la seguridad de aplicaciones web y APIs mediante la automatización de pruebas de penetración. Fue elegido por su flexibilidad y amplia base de pruebas predefinidas para identificar vulnerabilidades comunes.

### Trivy (Container Security Scanning)
Analiza vulnerabilidades en imágenes de contenedores y dependencias de código, permitiendo detectar fallas antes de que lleguen a producción. Se incorporó porque proporciona un análisis rápido y detallado, esencial en entornos de desarrollo basados en contenedores.

### DefectDojo (Plataforma de gestion de vulnerabilidades)
Plataforma de gestión de vulnerabilidades que centraliza los resultados de los escaneos de seguridad. Permite realizar seguimiento de hallazgos, gestionar riesgos y mejorar la visibilidad del estado de seguridad en el desarrollo. Se eligió para facilitar la organización y priorización de las vulnerabilidades detectadas en todo el proceso DevSecOps.

##Conclusión

Este repositorio está pensado para desarrolladores y equipos de seguridad que buscan implementar DevSecOps de manera efectiva, usando herramientas Free, asegurando que la seguridad no sea una fase adicional, sino un componente esencial del desarrollo de software.
