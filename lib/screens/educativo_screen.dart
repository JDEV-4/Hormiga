import 'package:flutter/material.dart';
import 'package:hormiga/screens/detalle_amenaza_screen.dart';

/// --- Pantalla de bienvenida del Qui
class QuizWelcomeScreen extends StatefulWidget {
  const QuizWelcomeScreen({super.key});

  @override
  State<QuizWelcomeScreen> createState() => _QuizWelcomeScreenState();
}

class _QuizWelcomeScreenState extends State<QuizWelcomeScreen>
    with TickerProviderStateMixin {
  bool showDot1 = false;
  bool showDot2 = false;
  bool showDot3 = false;
  bool showCloud = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => showDot1 = true);

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => showDot2 = true);

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => showDot3 = true);

    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => showCloud = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido
          Column(
            children: [
              const SizedBox(height: 40),
              const Spacer(),

              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Image.asset(
                      "assets/images/Hormiga.png",
                      height: 300,
                    ),
                  ),

                  // Puntits animados en diagonal
                  if (showDot1)
                    Positioned(
                      top: 40,
                      left: MediaQuery.of(context).size.width / 2 - 47,
                      child: _buildDot(8),
                    ),
                  if (showDot2)
                    Positioned(
                      top: 20,
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      child: _buildDot(12),
                    ),
                  if (showDot3)
                    Positioned(
                      top: 0,
                      left: MediaQuery.of(context).size.width / 2 - 10,
                      child: _buildDot(18),
                    ),

                  // Globo de pensamiento animado (fade-in)
                  if (showCloud)
                    Positioned(
                      top: -128,
                      left: 80,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: showCloud ? 1 : 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          constraints: const BoxConstraints(maxWidth: 220),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            "¡Hola! Soy tu amiga la Hormiga del SINAPRED.\nTe voy a guiar en este Quiz.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 40),

              // Botón
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.greenAccent[700],
                  shadowColor: Colors.black45,
                  elevation: 6,
                ),
                onPressed: () {
                  // Navegación al Quiz
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 28,
                  color: Colors.white,
                ),
                label: const Text(
                  "¡Comenzar!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(double size) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: 1,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// --- Pantalla principal Educativo ---
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

  /// --- Sección Aprende ---
  Widget _buildAprende() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
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
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
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
    );
  }

  /// --- Sección Descargas ---
  Widget _buildDescargas() {
    return const Center(
      child: Text(
        "Sección Descargas (PDFs e infografías próximamente)",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// --- Build principal ---
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
        children: [
          _buildAprende(),
          const QuizWelcomeScreen(),
          _buildDescargas(),
        ],
      ),
    );
  }
}
