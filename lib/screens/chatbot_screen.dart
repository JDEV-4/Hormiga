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

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida automático
    _messages.add({
      "role": "bot",
      "text":
          "👋 Hola, soy La Hormiga 🐜. ¿Quieres aprender sobre prevención o reportar un incidente?",
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

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
    final primaryColor = const Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot La Hormiga"),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isUser)
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/Hormiga.png",
                        ),
                        radius: 18,
                      ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? primaryColor.withOpacity(0.15)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg["text"] ?? "",
                          style: TextStyle(
                            color: isUser ? primaryColor : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Input del usuario
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe tu mensaje...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
