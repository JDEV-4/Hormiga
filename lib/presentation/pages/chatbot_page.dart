import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:async';

// IMPORTA la página de reporte (ajusta la ruta si tu archivo está en otra carpeta)
import 'report_incident_page.dart';

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
              Image.asset('assets/img/Saludando.png', height: 160),
              const SizedBox(height: 30),
              const Text('¡Hola! Soy Anto ',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
              const SizedBox(height: 10),
              const Text('Estoy aquí para ayudarte con lo que necesites.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotPage()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Hablar con Anto', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF234A68),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

// CHATBOT
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  // Ajusta la IP según tu red / dispositivo
  final String rasaUrl = Platform.isAndroid
      ? 'http://10.45.219.206:5005/webhooks/rest/webhook'
      : 'http://localhost:5005/webhooks/rest/webhook';

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": message});
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

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

        // Acumulador de botones (para agruparlos en un solo "mensaje de botones")
        final List<Map<String, dynamic>> buttonsAccumulator = [];

        for (var res in responses) {
          if (res.containsKey('text')) {
            setState(() {
              _messages.add({"sender": "bot", "message": res['text']});
            });
          }

          if (res.containsKey('buttons')) {
            for (var button in res['buttons']) {
              buttonsAccumulator.add({"title": button['title'], "payload": button['payload']});
            }
          }
        }

        if (buttonsAccumulator.isNotEmpty) {
          setState(() {
            _messages.add({"sender": "bot", "isButtonGroup": true, "buttons": buttonsAccumulator});
          });
        }
      } else {
        setState(() {
          _messages.add({"sender": "bot", "message": "Hubo un problema al conectar con el servidor 😕"});
        });
      }
    } on TimeoutException {
      setState(() {
        _messages.add({"sender": "bot", "message": "El servidor tardó demasiado en responder 😕"});
      });
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "message": "Error al enviar el mensaje: $e"});
      });
    }

    setState(() {
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _handleButtonPayload(String payload) {
    // Si el payload es navegación local:
    if (payload.startsWith('/reportar_incidente')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportIncidentPage()));
    } else {
      // Reenviamos el payload como mensaje al servidor (si así lo quieres)
      _sendMessage(payload);
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final bool isUser = message['sender'] == 'user';

    // Grupo de botones enviado por el bot
    if (message['isButtonGroup'] == true) {
      final List buttons = message['buttons'] as List;
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 2), blurRadius: 6)],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: buttons.map<Widget>((b) {
                  final title = b['title'] ?? '';
                  final payload = b['payload'] ?? '';
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 36),
                    child: OutlinedButton(
                      onPressed: () => _handleButtonPayload(payload),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00796B)),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        foregroundColor: const Color(0xFF00796B),
                      ),
                      child: Text(title, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }

    // Mensajes normales con burbuja
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.73),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF00695C) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(6),
            bottomRight: isUser ? const Radius.circular(6) : const Radius.circular(16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(2, 2), blurRadius: 4)],
        ),
        child: Text(
          message['message'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser)
          // --- AQUI: Avatar del bot ahora usa la imagen 'Saludando.png' ---
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 6.0),
            child: CircleAvatar(
              radius: 18, // ajusta el tamaño si quieres más grande/pequeño
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/img/Saludando.png'),
            ),
          ),
        Flexible(child: bubble),
        if (isUser)
          const Padding(
            padding: EdgeInsets.only(left: 6.0, right: 8.0),
            child: CircleAvatar(backgroundColor: Color(0xFF004D40), child: Icon(Icons.person, color: Colors.white)),
          ),
      ],
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))
          ]),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => _sendMessage(value.trim()),
                  decoration: const InputDecoration(
                    hintText: "Escribe un mensaje...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF234A68)),
                onPressed: () => _sendMessage(_controller.text.trim()),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    // Esperamos a que se renderice el nuevo elemento
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anto, tu asistente ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color(0xFF234A68),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: _buildMessage(_messages[index]),
                  );
                },
              ),
            ),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Align(alignment: Alignment.centerLeft, child: Text("Anto está escribiendo...", style: TextStyle(color: Colors.grey))),
              ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
}
