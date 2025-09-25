import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hormiga/screens/mapa_incidentes_screen.dart';
import 'package:hormiga/screens/educativo_screen.dart';
import 'package:hormiga/screens/chatbot_screen.dart';
import 'package:hormiga/screens/ReporteScreen.dart';
import 'package:hormiga/screens/notificaciones_screen.dart';
import '../widgets/feed_card.dart';
import '../models/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Post> posts = [
    Post(
      author: 'Alcaldía de Jinotepe',
      time: '10 Mayo',
      text:
          'SINAPRED, con apoyo de UNICEF, promueve la capacitación de las Brigadas Municipales de Respuesta (BRIMUR).',
      image: 'assets/images/Alcaldia.jpg',
      likes: 231,
      comments: 21,
      type: "municipality",
      avatarUrl: "assets/images/JINOTEPE.png",
    ),
    Post(
      author: 'SINAPRED',
      time: '6 Mayo',
      text:
          'Autoridades brindan informe sobre comportamientos y efectos de tormenta tropical Sara en Nicaragua.',
      image: 'assets/images/cortez.jpg',
      likes: 356,
      comments: 21,
      type: "official",
      avatarUrl: "assets/images/SINAPRED.jpg",
    ),
    Post(
      author: 'Carlos Gómez',
      time: '7 Mayo',
      text: 'Fuerte lluvia en mi barrio, calles inundadas.',
      image: 'assets/images/colapso.jpg',
      likes: 89,
      comments: 12,
      type: "citizen",
      avatarUrl: "assets/images/Avatar.png",
    ),
  ];

  // Lista de notificaciones
  final List<Map<String, String>> notificaciones = [
    {
      'mensaje': 'Alerta: Deslave reportado cerca de tu ubicación',
      'tipo': 'deslave',
    },
    {'mensaje': 'Tormenta tropical Sara: Mantente seguro', 'tipo': 'tormenta'},
    {'mensaje': 'Incendio forestal en Masaya', 'tipo': 'incendio'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Post> officialPosts = posts
        .where((p) => p.type == "official")
        .toList();
    List<Post> otherPosts = posts.where((p) => p.type != "official").toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage("assets/images/Avatar.png"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Juan Pérez",
                            style: GoogleFonts.sourceSans3(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "juanperez@email.com",
                            style: GoogleFonts.sourceSans3(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerTile(Icons.school, "Módulo Educativo", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EducativoScreen(),
                        ),
                      );
                    }),
                    _buildDrawerTile(Icons.map, "Mapa de Incidentes", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MapaIncidentesScreen(),
                        ),
                      );
                    }),
                    _buildDrawerTile(
                      Icons.report,
                      "Reportar Incidente",
                      () async {
                        final reporte = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReporteScreen(),
                          ),
                        );
                        if (reporte != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MapaIncidentesScreen(reporteInicial: reporte),
                            ),
                          );
                        }
                      },
                    ),
                    _buildDrawerTile(Icons.people, "Comunidad", () {}),
                    _buildDrawerTile(Icons.bar_chart, "Estadísticas", () {}),
                    _buildDrawerTile(Icons.chat, "Chatbot La Hormiga", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatbotScreen(),
                        ),
                      );
                    }),
                    const Divider(height: 30, thickness: 1),
                    _buildDrawerTile(Icons.settings, "Configuración", () {}),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Colors.redAccent),
                        const SizedBox(width: 12),
                        Text(
                          "Cerrar Sesión",
                          style: GoogleFonts.sourceSans3(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1976D2),
        elevation: 2,
        title: Text(
          "SINAPRED - La Hormiga",
          style: GoogleFonts.sourceSans3(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Campana con conteo de notificaciones
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NotificacionesScreen(notificaciones: notificaciones),
                    ),
                  );
                },
              ),
              if (notificaciones.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${notificaciones.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Avatar.png"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          for (final p in officialPosts) FeedCard(post: p),
          const Divider(),
          for (final p in otherPosts) FeedCard(post: p),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: GoogleFonts.sourceSans3(fontSize: 16)),
      onTap: onTap,
    );
  }
}
