import 'package:flutter/material.dart';
import 'quiz_welcome_screen.dart';

class DetalleAmenazaScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String icono;

  const DetalleAmenazaScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(icono, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                children: const [
                  Text(
                    "👉 Antes del evento:\n- Ten lista tu mochila de emergencia.\n- Identifica zonas seguras.\n",
                  ),
                  SizedBox(height: 10),
                  Text(
                    "👉 Durante:\n- Mantén la calma.\n- Aléjate de ventanas.\n",
                  ),
                  SizedBox(height: 10),
                  Text(
                    "👉 Después:\n- Revisa daños.\n- Escucha la radio para información oficial.\n",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.greenAccent[700],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const QuizWelcomeScreen(), // 👈 Aquí referencia
                  ),
                );
              },
              icon: const Icon(Icons.quiz, color: Colors.white),
              label: const Text(
                "Ir al Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
