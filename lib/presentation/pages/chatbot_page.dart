import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:async';

// PANTALLA DE BIENVENIDA
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de Anto
              Image.asset(
                'assets/img/anto.png',
                height: 160,
              ),
              const SizedBox(height: 30),
              const Text(
                '¡Hola! Soy Anto ',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Estoy aquí para ayudarte con lo que necesites.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotPage()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text(
                  'Hablar con Anto',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PÁGINA DEL CHATBOT
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  final String rasaUrl = Platform.isAndroid
      ? 'http://10.0.2.2:5005/webhooks/rest/webhook'
      : 'http://localhost:5005/webhooks/rest/webhook';

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": message});
      _isTyping = true;
    });

    _controller.clear();

    try {
      final response = await http
          .post(
            Uri.parse(rasaUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"sender": "user", "message": message}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> responses = jsonDecode(response.body);
        for (var res in responses) {
          if (res.containsKey('text')) {
            setState(() {
              _messages.add({"sender": "bot", "message": res['text']});
            });
          }

          if (res.containsKey('buttons')) {
            for (var button in res['buttons']) {
              setState(() {
                _messages.add({
                  "sender": "bot",
                  "message": button['title'],
                  "payload": button['payload'],
                  "isButton": true,
                });
              });
            }
          }
        }
      } else {
        setState(() {
          _messages.add({
            "sender": "bot",
            "message": "Hubo un problema al conectar con el servidor 😕"
          });
        });
      }
    } on TimeoutException {
      setState(() {
        _messages.add({
          "sender": "bot",
          "message": "El servidor tardó demasiado en responder 😕"
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "message": "Error al enviar el mensaje: $e"
        });
      });
    }

    setState(() {
      _isTyping = false;
    });
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final bool isUser = message['sender'] == 'user';

    if (message['isButton'] == true) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              _sendMessage(message['payload']);
            },
            child: Text(
              message['message'],
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      );
    }

    // Mensajes con avatar
    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF00695C) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft:
              isUser ? const Radius.circular(16) : const Radius.circular(0),
          bottomRight:
              isUser ? const Radius.circular(0) : const Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Text(
        message['message'],
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 15,
        ),
      ),
    );

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser)
          const CircleAvatar(
            backgroundColor: Color(0xFF00796B),
            child: Text("A", style: TextStyle(color: Colors.white)),
          ),
        Flexible(child: bubble),
        if (isUser)
          const CircleAvatar(
            backgroundColor: Color(0xFF004D40),
            child: Icon(Icons.person, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Escribe un mensaje...",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Color(0xFF00796B)),
              onPressed: () => _sendMessage(_controller.text.trim()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anto, tu asistente ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: _buildMessage(_messages[index]),
                  );
                },
              ),
            ),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Anto está escribiendo...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
}
