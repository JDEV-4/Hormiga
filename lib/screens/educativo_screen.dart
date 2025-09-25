import 'package:flutter/material.dart';
import 'detalle_amenaza_screen.dart';

class EducativoScreen extends StatelessWidget {
  const EducativoScreen({super.key});

  final List<Map<String, dynamic>> amenazas = const [
    {
      "titulo": "Sismos",
      "descripcion":
          "¿Sabes qué hacer antes, durante y después de un sismo? Prepárate y protege a tu familia.",
      "color": Colors.redAccent,
      "tag": "sismo",
      "imagen": "assets/images/SISMO.png",
    },
    {
      "titulo": "Deslaves",
      "descripcion":
          "Aprende cómo prevenir y actuar ante deslaves o derrumbes en tu comunidad.",
      "color": Colors.brown,
      "tag": "deslave",
      "imagen": "assets/images/DESLAVE.png",
    },
    {
      "titulo": "Incendios",
      "descripcion":
          "Evita riesgos y conoce las medidas para enfrentar un incendio en tu comunidad.",
      "color": Colors.orangeAccent,
      "tag": "incendio",
      "imagen": "assets/images/INCENDIO.png",
    },
    {
      "titulo": "Huracanes",
      "descripcion":
          "Infórmate sobre los protocolos de seguridad frente a huracanes y tormentas.",
      "color": Colors.teal,
      "tag": "huracan",
      "imagen": "assets/images/HURACAN.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Módulo Educativo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Conoce cómo actuar ante amenazas naturales y protege a tu comunidad.",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: amenazas.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final amenaza = amenazas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => DetalleAmenazaScreen(
                          titulo: amenaza["titulo"],
                          descripcion: amenaza["descripcion"],
                          tag: amenaza["tag"],
                          color: amenaza["color"],
                          imagen: amenaza["imagen"],
                        ),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          amenaza["imagen"],
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          amenaza["titulo"],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          amenaza["descripcion"],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
