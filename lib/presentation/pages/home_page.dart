import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/organisms/post_card.dart';
import 'create_post_page.dart';
import 'report_incident_page.dart'; 
import 'mapa_incidentes_page.dart';
import 'chatbot_page.dart'; // <--- Importa tu página del chatbot

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
        statusBarColor: const Color(0xFF006D65),
      ),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF006D65),
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://www.pngarts.com/files/5/User-Avatar-PNG-Transparent-Image.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        drawer: _buildDrawer(context),

        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.errorMessage != null
                ? Center(
                    child: Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  )
                : controller.posts.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay publicaciones disponibles',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: controller.loadPosts,
                        child: ListView.builder(
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) =>
                              PostCard(post: controller.posts[index]),
                        ),
                      ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF006D65),
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
            color: const Color(0xFF006D65),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://www.pngarts.com/files/5/User-Avatar-PNG-Transparent-Image.png',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Juan Pérez',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Administrador',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildMenuItem(Icons.report, 'Reportar Incidente', Colors.red,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ReportIncidentPage()),
                  );
                }),
                _buildMenuItem(Icons.map, 'Mapa de Incidentes', Colors.green, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapaIncidentesPage()),
                  );
                }),
                _buildMenuItem(Icons.school, 'Módulo Educativo', Colors.blue, () {}),
                const Divider(),
                _buildMenuItem(Icons.groups, 'Comunidad', Colors.orange, () {}),
                _buildMenuItem(Icons.chat_bubble, 'Chatbot de la Hormiga',
                    Colors.teal, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotPage()),
                  );
                }),
                const Divider(),
                _buildMenuItem(Icons.bar_chart, 'Estadísticas', Colors.purple, () {}),
                _buildMenuItem(Icons.settings, 'Configuración', Colors.grey, () {}),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildMenuItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
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
