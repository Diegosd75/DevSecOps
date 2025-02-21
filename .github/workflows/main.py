from flask import Flask, request, jsonify
import subprocess
import os
import pickle

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Calculadora DevSecOps</h1>"

@app.route('/calculate', methods=['POST'])
def calculate():
    data = request.get_json()
    if not data or 'num1' not in data or 'num2' not in data or 'operation' not in data:
        return jsonify({"error": "Invalid input"}), 400
    
    num1 = data['num1']
    num2 = data['num2']
    operation = data['operation']
    
    try:
        if operation == 'add':
            result = num1 + num2
        elif operation == 'subtract':
            result = num1 - num2
        elif operation == 'multiply':
            result = num1 * num2
        elif operation == 'divide':
            if num2 == 0:
                return jsonify({"error": "Cannot divide by zero"}), 400
            result = num1 / num2
        elif operation == 'exec':
            # Vulnerabilidad: Inyección de comandos
            result = subprocess.check_output(data['command'], shell=True).decode()
        elif operation == 'deserialize':
            # Vulnerabilidad: Deserialización insegura
            result = pickle.loads(bytes.fromhex(data['payload']))
        elif operation == 'env':
            # Vulnerabilidad: Exposición de variables de entorno
            result = os.environ.get(data.get('env_var', ''))
        else:
            return jsonify({"error": "Unsupported operation"}), 400
        
        return jsonify({"result": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
