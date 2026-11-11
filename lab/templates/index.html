<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asistente de Viajes - TurisIA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .chat-card { max-width: 800px; margin: 30px auto; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .chat-header { background: linear-gradient(135deg, #0d6efd, #0a58ca); color: white; border-radius: 15px 15px 0 0; padding: 20px; }
        .chat-box { height: 450px; overflow-y: auto; padding: 20px; background-color: #ffffff; }
        .message { margin-bottom: 15px; display: flex; flex-direction: column; }
        .message.user { align-items: flex-end; }
        .message.bot { align-items: flex-start; }
        .bubble { max-width: 75%; padding: 12px 18px; border-radius: 18px; font-size: 0.95rem; line-height: 1.4; }
        .message.user .bubble { background-color: #0d6efd; color: white; border-bottom-right-radius: 4px; }
        .message.bot .bubble { background-color: #e9ecef; color: #212529; border-bottom-left-radius: 4px; }
        .chat-footer { padding: 15px; background-color: #f8f9fa; border-top: 1px solid #dee2e6; border-radius: 0 0 15px 15px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card chat-card">
        <div class="chat-header text-center">
            <h4 class="mb-1">✈️ Asistente Virtual de Turismo</h4>
            <small>Recomendaciones inteligentes desde Chile</small>
        </div>
        <div class="chat-box" id="chatBox">
            <div class="message bot">
                <div class="bubble">
                    ¡Hola! Soy tu asistente de viajes. ¿A dónde te gustaría viajar o qué tipo de experiencia buscas? Puedo recomendarte destinos según tu presupuesto, preferencias de clima, continentes o duración del viaje.
                </div>
            </div>
        </div>
        <div class="chat-footer">
            <form id="chatForm" class="d-flex gap-2">
                <input type="text" id="userInput" class="form-control" placeholder="Escribe tu consulta aquí (ej: Recomiéndame un destino cálido con USD 2000)..." required autocomplete="off">
                <button type="submit" class="btn btn-primary px-4">Enviar</button>
            </form>
        </div>
    </div>
</div>

<script>
    const chatBox = document.getElementById('chatBox');
    const chatForm = document.getElementById('chatForm');
    const userInput = document.getElementById('userInput');
    let conversationHistory = [];

    chatForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const message = userInput.value.trim();
        if (!message) return;

        appendMessage('user', message);
        userInput.value = '';

        const loadingDiv = appendLoading();

        try {
            const response = await fetch('/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message, history: conversationHistory })
            });
            const data = await response.json();
            
            chatBox.removeChild(loadingDiv);
            appendMessage('bot', data.response);

            conversationHistory.push({ sender: 'user', text: message });
            conversationHistory.push({ sender: 'bot', text: data.response });

        } catch (error) {
            chatBox.removeChild(loadingDiv);
            appendMessage('bot', 'Error de conexión con el servidor.');
        }
    });

    function appendMessage(sender, text) {
        const msgDiv = document.createElement('div');
        msgDiv.classList.add('message', sender);
        msgDiv.innerHTML = `<div class="bubble">${text.replace(/\n/g, '<br>')}</div>`;
        chatBox.appendChild(msgDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function appendLoading() {
        const loadDiv = document.createElement('div');
        loadDiv.classList.add('message', 'bot');
        loadDiv.innerHTML = `<div class="bubble"><em>Pensando respuesta...</em></div>`;
        chatBox.appendChild(loadDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
        return loadDiv;
    }
</script>
</body>
</html>