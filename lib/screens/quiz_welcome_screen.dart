import 'package:flutter/material.dart';

class QuizWelcomeScreen extends StatefulWidget {
  final Color? color;

  const QuizWelcomeScreen({super.key, this.color});

  @override
  State<QuizWelcomeScreen> createState() => _QuizWelcomeScreenState();
}

class _QuizWelcomeScreenState extends State<QuizWelcomeScreen>
    with TickerProviderStateMixin {
  bool showDot1 = false;
  bool showDot2 = false;
  bool showDot3 = false;
  bool showCloud = false;

  // Paleta de colores
  static const Color kAppBarBlue = Color(0xFF1976D2); // Azul del HomeScreen
  static const Color kBackground = Color(0xFFE3F2FD); // Azul cielo claro
  static const Color kTextDark = Color(0xFF333333); // Gris oscuro
  static const Color kDialogWhite = Color(0xFFFFFFFF); // Blanco puro
  static const Color kShadow = Color(0x42000000); // Negro translúcido

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
    final Color mainColor = widget.color ?? kAppBarBlue;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "Quiz de Sismos",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        elevation: 2,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo
          Container(
            width: double.infinity,
            height: double.infinity,
            color: kBackground,
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
                  // Puntos animados
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
                  // Globo de diálogo
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
                            color: kDialogWhite,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: kShadow,
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
                              color: kTextDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              // Botón comenzar
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: mainColor,
                  shadowColor: Colors.black45,
                  elevation: 6,
                ),
                onPressed: () {},
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
