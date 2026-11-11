import os
import json
from flask import Flask, render_template, request, jsonify
from google import genai
from google.genai import types
# import google.generativeai as genai

app = Flask(__name__)

# Configuración del cliente Gemini API
API_KEY = os.environ.get("GEMINI_API_KEY", "TU_API_KEY_AQUI")
client = genai.Client(api_key=API_KEY)

# Base de conocimiento estructurada extraída fielmente de Prolog (proyecto2.pl)
KNOWLEDGE_BASE = """
BASE DE CONOCIMIENTO DE DESTINOS TURÍSTICOS (ORIGEN: CHILE):

- Japón: Continente Asia | Costo: USD 3000 | Clima: templado | Reseña: 4.5/5 | Visa requerida: No (false) | Vuelo: 26 hrs (17000 km) | Días mínimos sugeridos: 10
- China: Continente Asia | Costo: USD 2500 | Clima: templado | Reseña: 4.2/5 | Visa requerida: No (false) | Vuelo: 27 hrs (19000 km) | Días mínimos sugeridos: 12
- Egipto: Continente África | Costo: USD 2000 | Clima: cálido | Reseña: 4.0/5 | Visa requerida: No (false) | Vuelo: 21 hrs (12500 km) | Días mínimos sugeridos: 8
- Argentina: Continente América | Costo: USD 1500 | Clima: templado | Reseña: 4.3/5 | Visa requerida: No (false) | Vuelo: 2 hrs (1100 km) | Días mínimos sugeridos: 5
- Brasil: Continente América | Costo: USD 1800 | Clima: cálido | Reseña: 4.1/5 | Visa requerida: No (false) | Vuelo: 4 hrs (3000 km) | Días mínimos sugeridos: 7
- México: Continente América | Costo: USD 2200 | Clima: cálido | Reseña: 4.4/5 | Visa requerida: No (false) | Vuelo: 9 hrs (6600 km) | Días mínimos sugeridos: 6
- Australia: Continente Oceanía | Costo: USD 3500 | Clima: templado | Reseña: 4.6/5 | Visa requerida: Sí (true) | Vuelo: 13.5 hrs (11200 km) | Días mínimos sugeridos: 14
- Francia: Continente Europa | Costo: USD 4000 | Clima: templado | Reseña: 4.7/5 | Visa requerida: No (false) | Vuelo: 14 hrs (11600 km) | Días mínimos sugeridos: 8
- Italia: Continente Europa | Costo: USD 3800 | Clima: templado | Reseña: 4.8/5 | Visa requerida: No (false) | Vuelo: 15 hrs (11900 km) | Días mínimos sugeridos: 10
- España: Continente Europa | Costo: USD 3600 | Clima: templado | Reseña: 4.5/5 | Visa requerida: No (false) | Vuelo: 12 hrs (10700 km) | Días mínimos sugeridos: 10

REGLA DE EVALUACIÓN DE PUNTAJE DE ATRACTIVO:
Puntaje = (Reseña * 20) - (Costo * 0.005) - (DistanciaKm * 0.001)
"""

SYSTEM_INSTRUCTION = f"""
Eres el Asistente Inteligente de Turismo Experto en recomendaciones de viajes partiendo desde Chile.
Tu objetivo es ayudar a los usuarios a planificar viajes y responder sus dudas de forma amable, precisa y fluida en lenguaje natural.

REGLAS DE OPERACIÓN ESTRICTAS:
1. Debes basar todas tus respuestas técnicas (costos, climas, horas de vuelo, visa, días mínimos y continentes) EXCLUSIVAMENTE en la siguiente Base de Conocimiento:
{KNOWLEDGE_BASE}

2. Si el usuario pide recomendaciones, evalúa sus restricciones (presupuesto, días, clima, visa) y presenta las opciones ordenadas priorizando las de mayor valor según las restricciones expresadas.
3. Si el usuario consulta sobre un país que NO está en la base de datos, explica amablemente que por el momento tu catálogo está acotado a los 10 destinos registrados partiendo desde Chile.
4. Mantén una conversación natural, profesional y cercana.
"""

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    user_message = data.get('message', '')
    history = data.get('history', [])
    
    contents = []
    for msg in history:
        role = "user" if msg['sender'] == 'user' else "model"
        contents.append(types.Content(role=role, parts=[types.Part.from_text(text=msg['text'])]))
    
    contents.append(types.Content(role="user", parts=[types.Part.from_text(text=user_message)]))
    
    config = types.GenerateContentConfig(
        system_instruction=SYSTEM_INSTRUCTION,
        temperature=0.3,
    )
    
    try:
        response = client.models.generate_content(
            model='gemini-3.8-flash',
            contents=contents,
            config=config
        )
        return jsonify({'response': response.text})
    except Exception as e:
        return jsonify({'response': f"Error al procesar la solicitud: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)