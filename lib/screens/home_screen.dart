import 'package:flutter/material.dart';
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
          'SINAPRED, con el apoyo técnico y financiero de UNICEF, promueve la incorporación del enfoque de derechos de la niñez en el Manual básico de capacitación y entrenamiento a las Brigadas Municipales de Respuesta (BRIMUR).',
      image: 'assets/images/Alcaldia.jpg',
      likes: 231,
      comments: 21,
    ),
    Post(
      author: 'SINAPRED',
      time: '6 Mayo',
      text:
          'Autoridades brindan informe sobre comportamientos y efectos de tormenta tropical Sara en Nicaragua.',
      image: 'assets/images/cortez.jpg',
      likes: 356,
      comments: 21,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer lateral
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header PARA centra avatar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage("assets/images/Avatar.png"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Juan Pérez",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "juanperez@email.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text("Módulo Educativo"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.green),
              title: const Text("Mapa de Incidentes"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.orange),
              title: const Text("Comunidad"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.purple),
              title: const Text("Estadísticas"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.redAccent),
              title: const Text("Chatbot La Hormiga"),
              onTap: () {},
            ),
            const Divider(height: 30, thickness: 1),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text("Configuración"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar Sesión"),
              onTap: () {},
            ),
          ],
        ),
      ),

      // 🔹 AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1976D2),
        elevation: 2,
        title: const Text(
          "SINAPRED - La Hormiga",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // lógica de notificaciones
            },
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

      // Feed de noticias
      body: ListView(
        children: [
          const SizedBox(height: 8),
          for (final p in posts) FeedCard(post: p),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
