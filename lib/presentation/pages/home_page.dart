// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/organisms/post_card.dart';
import 'create_post_page.dart';
import 'report_incident_page.dart';
import 'mapa_incidentes_page.dart';
import 'chatbot_page.dart';
import 'educational_module_page.dart';
import 'welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const Color azul = Color(0xFF234A68);

  @override
  void initState() {
    super.initState();
    // Cargar publicaciones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: azul,
      ),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: azul,
          title: const Text(
            'La Hormiga',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/avatar.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        drawer: _buildDrawer(context),

      
                   

        floatingActionButton: FloatingActionButton(
          backgroundColor: azul,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostPage()),
            );

            if (result != null && result == true) {
              await context.read<HomeController>().loadPosts();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
            color: azul,
            
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildMenuItem(Icons.report, 'Reportar Incidente', Colors.red, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportIncidentPage()),
                  );
                }),
                _buildMenuItem(Icons.map, 'Mapa de Incidentes', Colors.green, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapaIncidentesPage()),
                  );
                }),
                _buildMenuItem(Icons.school, 'Módulo Educativo', Colors.blue, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EducationalModulePage()),
                  );
                }),
                const Divider(),
                _buildMenuItem(Icons.chat_bubble, 'Conversa con Anto', Colors.teal, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotPage()),
                  );
                }),
                const Divider(),
                _buildMenuItem(Icons.settings, 'Configuración', Colors.grey, () {}),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(40),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      hoverColor: Colors.grey[200],
      onTap: onTap,
    );
  }
}
