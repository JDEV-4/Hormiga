import 'package:flutter/material.dart';
import 'quiz_welcome_screen.dart';

class DetalleAmenazaScreen extends StatefulWidget {
  final String titulo;
  final String descripcion;
  final String tag;
  final Color color;
  final String imagen;

  const DetalleAmenazaScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.tag,
    required this.color,
    required this.imagen,
  });

  @override
  State<DetalleAmenazaScreen> createState() => _DetalleAmenazaScreenState();
}

class _DetalleAmenazaScreenState extends State<DetalleAmenazaScreen> {
  int etapaActual = 0;
  late final List<Map<String, dynamic>> leccion;

  @override
  void initState() {
    super.initState();
    leccion = _obtenerContenido(widget.titulo);
  }

  List<Map<String, dynamic>> _obtenerContenido(String titulo) {
    final Map<String, List<Map<String, dynamic>>> contenido = {
      "Sismos": [
        {
          "etapa": "Antes del evento",
          "acciones": [
            "Ten lista tu mochila de emergencia con agua, radio, linterna y documentos.",
            "Identifica zonas seguras y practica simulacros.",
            "Habla con tu familia sobre qué hacer en caso de sismo.",
          ],
          "frase": "¡Prepárate bien! La prevención salva vidas.",
        },
        {
          "etapa": "Durante el evento",
          "acciones": [
            "Mantén la calma y protégete bajo una mesa resistente.",
            "Aléjate de ventanas y objetos que puedan caer.",
            "No uses elevadores ni salgas corriendo.",
          ],
          "frase": "¡Mantén la calma! Cada segundo cuenta.",
        },
        {
          "etapa": "Después del evento",
          "acciones": [
            "Revisa daños y corta la electricidad si es necesario.",
            "Ayuda a otros si puedes hacerlo con seguridad.",
            "Escucha la radio para recibir información oficial.",
          ],
          "frase": "¡Actúa con cuidado! Tu comunidad te necesita.",
        },
      ],
    };

    return contenido[titulo] ?? [];
  }

  void avanzarEtapa() {
    if (etapaActual < leccion.length - 1) {
      setState(() {
        etapaActual++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizWelcomeScreen(color: widget.color),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final etapa = leccion[etapaActual];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.color,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      widget.imagen,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/Hormiga.png',
                        height: 110,
                        width: 110,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.descripcion,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    etapa["frase"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    etapa["etapa"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(etapa["acciones"].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: widget.color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                etapa["acciones"][index],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: widget.color,
                  elevation: 6,
                ),
                onPressed: avanzarEtapa,
                icon: Icon(
                  etapaActual < leccion.length - 1
                      ? Icons.arrow_forward
                      : Icons.quiz,
                  color: Colors.white,
                ),
                label: Text(
                  etapaActual < leccion.length - 1
                      ? "Siguiente etapa"
                      : "Ir al Quiz",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
