import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  //localhost
  final String _rasaUrl = "http://192.168.1.55:5005/webhooks/rest/webhook"; //IP

  // Función para enviar mensaje a Rasa
  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    // Agregar mensaje del usuario al chat
    setState(() {
      _messages.add({"role": "user", "text": text});
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(_rasaUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"sender": "usuario_flutter", "message": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          for (var msg in data) {
            setState(() {
              _messages.add({"role": "bot", "text": msg["text"] ?? ""});
            });
          }
        } else {
          setState(() {
            _messages.add({
              "role": "bot",
              "text": "El bot no respondió, intenta de nuevo.",
            });
          });
        }
      } else {
        setState(() {
          _messages.add({
            "role": "bot",
            "text":
                "Error al conectar con el bot. Código HTTP: ${response.statusCode}",
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "bot",
          "text":
              "No se pudo conectar con el servidor. Revisa que Rasa esté corriendo y que tu teléfono esté en la misma red.",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot La Hormiga"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          // Avatar del bot
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset("assets/images/Hormiga.png", width: 120),
                const SizedBox(height: 8),
                const Text(
                  "Soy La Hormiga 🐜, tu asistente de prevención.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Divider(),

          // Mensajes
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Container(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["text"] ?? ""),
                  ),
                );
              },
            ),
          ),

          // Input del usuario
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
