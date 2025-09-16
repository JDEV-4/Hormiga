import 'package:flutter/material.dart';
import '../widgets/feed_card.dart';
import '../models/post.dart';
import 'educativo_screen.dart'; // 🔹 Importamos la nueva pantalla

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
      avatarUrl: "assets/images/JINOTEPE.png", // 🔹 avatar del autor
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
      avatarUrl: "assets/images/SINAPRED.jpg", // 🔹 avatar de SINAPRED
    ),
    Post(
      author: 'Carlos Gómez',
      time: '7 Mayo',
      text: 'Fuerte lluvia en mi barrio, calles inundadas.',
      image: 'assets/images/colapso.jpg',
      likes: 89,
      comments: 12,
      type: "citizen",
      avatarUrl: "assets/images/Avatar.png", // 🔹 avatar genérico
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // separar oficiales de los demás
    List<Post> officialPosts = posts
        .where((p) => p.type == "official")
        .toList();
    List<Post> otherPosts = posts.where((p) => p.type != "official").toList();

    return Scaffold(
      // Drawer lateral
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header usuario
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
            // 🔹 Navegar al módulo educativo
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text("Módulo Educativo"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EducativoScreen(),
                  ),
                );
              },
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
            onPressed: () {},
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

      // Feed
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
}
