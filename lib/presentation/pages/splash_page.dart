// lib/presentation/pages/splash_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  final Duration duration;
  const SplashPage({super.key, this.duration = const Duration(seconds: 3)});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const Color azul = Color(0xFF234A68);
  double _progress = 0.0;
  Timer? _timer;

  late final AnimationController _logoController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Animación ligera del logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoController.forward();

    // Progreso simulado
    final ticks = 60;
    final step = widget.duration.inMilliseconds ~/ ticks;
    int i = 0;
    _timer = Timer.periodic(Duration(milliseconds: step), (t) {
      i++;
      setState(() {
        _progress = (i / ticks).clamp(0.0, 1.0);
      });

      if (i >= ticks) {
        t.cancel();
        Future.delayed(const Duration(milliseconds: 300), _goToLogin);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final logoSize = (w * 0.45).clamp(120.0, 200.0);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado con tonos azulados
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE8EEF2),
                  Color(0xFFF5F8FA),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Círculos decorativos suaves
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: azul.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: azul.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Solo la imagen (sin contenedor blanco)
                  ScaleTransition(
                    scale: _logoScale,
                    child: Image.asset(
                      'assets/img/logo.png',
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.android,
                        size: logoSize * 0.6,
                        color: azul,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Título
                  Text(
                    'SINAPRED – La Hormiga',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azul,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtítulo
                  Text(
                    'Prevención y respuesta al alcance de todos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Barra de carga estilizada
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(azul),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${(_progress * 100).toInt()} %',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Botón de salto
          Positioned(
            top: 12,
            right: 12,
            child: TextButton(
              onPressed: _goToLogin,
              style: TextButton.styleFrom(foregroundColor: azul),
              child: const Text('Saltar'),
            ),
          ),

          // Footer versión
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0 • © La Hormiga',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
