import 'package:flutter/material.dart';

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
                  backgroundColor: Colors.greenAccent[700],
                  shadowColor: Colors.black45,
                  elevation: 6,
                ),
                onPressed: () {
                  // Aquí navegas al quiz real
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
