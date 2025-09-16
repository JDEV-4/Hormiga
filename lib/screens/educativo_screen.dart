import 'package:flutter/material.dart';

class EducativoScreen extends StatefulWidget {
  const EducativoScreen({super.key});

  @override
  State<EducativoScreen> createState() => _EducativoScreenState();
}

class _EducativoScreenState extends State<EducativoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> amenazas = [
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

  /// --- Preguntas del Quiz ---
  final List<Map<String, Object>> _preguntas = [
    {
      "pregunta": "¿Qué debes hacer durante un sismo?",
      "opciones": [
        "Salir corriendo",
        "Mantener la calma y buscar un lugar seguro",
        "Encender la estufa",
        "Quedarte en el ascensor",
      ],
      "respuesta": 1,
    },
    {
      "pregunta": "¿Cuál es la señal de evacuación en caso de incendio?",
      "opciones": [
        "Luz roja",
        "Sirena o alarma",
        "Campanas de iglesia",
        "Mensajes de texto",
      ],
      "respuesta": 1,
    },
    {
      "pregunta": "¿Qué hacer antes de un huracán?",
      "opciones": [
        "Esperar sin hacer nada",
        "Preparar un kit de emergencia",
        "Salir a nadar",
        "Encender fuegos artificiales",
      ],
      "respuesta": 1,
    },
  ];

  int _preguntaActual = -1; // -1 significa que aún no inicia
  int _puntaje = 0;
  bool _quizTerminado = false;

  final List<Map<String, dynamic>> _ranking = [
    {"nombre": "Ana", "puntaje": 8},
    {"nombre": "Carlos", "puntaje": 6},
    {"nombre": "Lucía", "puntaje": 5},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAprende() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: amenazas.length,
      itemBuilder: (context, index) {
        final amenaza = amenazas[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            leading: Text(
              amenaza["icono"]!,
              style: const TextStyle(fontSize: 28),
            ),
            title: Text(
              amenaza["titulo"]!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              amenaza["descripcion"]!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Abrir detalles de ${amenaza['titulo']}"),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// --- Vista del Quiz con la hormiga ---
  Widget _buildQuiz() {
    if (_preguntaActual == -1) {
      return _buildBienvenidaHormiga();
    }

    if (_quizTerminado) {
      return _buildResultadoHormiga();
    }

    final pregunta = _preguntas[_preguntaActual];
    final opciones = pregunta["opciones"] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHormigaBubble("¡Tú puedes! Responde con calma."),
          const SizedBox(height: 20),
          Card(
            color: Colors.blue[50],
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Pregunta ${_preguntaActual + 1}/${_preguntas.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pregunta["pregunta"] as String,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(opciones.length, (i) {
                    return Card(
                      child: ListTile(
                        title: Text(opciones[i]),
                        onTap: () {
                          setState(() {
                            if (i == pregunta["respuesta"]) {
                              _puntaje++;
                            }
                            if (_preguntaActual < _preguntas.length - 1) {
                              _preguntaActual++;
                            } else {
                              _quizTerminado = true;
                            }
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --- Pantalla de bienvenida con la hormiga ---
  Widget _buildBienvenidaHormiga() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/Hormiga.png", height: 120),
          const SizedBox(height: 20),
          _buildHormigaBubble(
            "👋 ¡Hola! Soy la Hormiga del SINAPRED.\nTe acompañaré en este Quiz.",
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _preguntaActual = 0;
              });
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text("Iniciar Quiz"),
          ),
        ],
      ),
    );
  }

  /// --- Pantalla de resultados con la hormiga ---
  Widget _buildResultadoHormiga() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/Hormiga.png", height: 120),
        const SizedBox(height: 20),
        _buildHormigaBubble("🎉 ¡Felicidades! Tu puntaje es $_puntaje."),
        const SizedBox(height: 20),
        const Text(
          "🏆 Ranking de jugadores",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _ranking.length,
            itemBuilder: (context, index) {
              final jugador = _ranking[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(jugador["nombre"]),
                  trailing: Text(
                    "Puntos: ${jugador['puntaje']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _preguntaActual = -1;
              _puntaje = 0;
              _quizTerminado = false;
            });
          },
          child: const Text("Reintentar"),
        ),
      ],
    );
  }

  /// --- Globito de diálogo de la hormiga ---
  Widget _buildHormigaBubble(String mensaje) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        mensaje,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescargas() {
    return const Center(
      child: Text(
        "Sección Descargas (PDFs e infografías próximamente)",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Módulo Educativo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.yellow,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: "Aprende"),
            Tab(icon: Icon(Icons.quiz), text: "Quiz"),
            Tab(icon: Icon(Icons.download), text: "Descargas"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAprende(), _buildQuiz(), _buildDescargas()],
      ),
    );
  }
}
