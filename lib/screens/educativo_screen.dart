import 'package:flutter/material.dart';
import 'detalle_amenaza_screen.dart';

class EducativoScreen extends StatelessWidget {
  const EducativoScreen({super.key});

  final List<Map<String, String>> amenazas = const [
    {
      "titulo": "Sismos",
      "descripcion":
          "Aprende qué hacer antes, durante y después de un sismo para mantenerte seguro.",
      "icono": "🌎",
    },
    {
      "titulo": "Inundaciones",
      "descripcion":
          "Conoce cómo prepararte y actuar frente a inundaciones en tu comunidad.",
      "icono": "🌊",
    },
    {
      "titulo": "Incendios",
      "descripcion":
          "Descubre las medidas preventivas y cómo reaccionar ante un incendio.",
      "icono": "🔥",
    },
    {
      "titulo": "Huracanes",
      "descripcion":
          "Infórmate sobre los protocolos de seguridad frente a huracanes.",
      "icono": "🌪️",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Módulo Educativo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: List.generate(amenazas.length, (index) {
            final amenaza = amenazas[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleAmenazaScreen(
                      titulo: amenaza["titulo"]!,
                      descripcion: amenaza["descripcion"]!,
                      icono: amenaza["icono"]!,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        amenaza["icono"]!,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        amenaza["titulo"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        amenaza["descripcion"]!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
