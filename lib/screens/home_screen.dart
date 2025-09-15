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
      text: 'Jinotepe recibe un nuevo camión recolector de basura.',
      image: 'assets/images/sample1.png',
      likes: 231,
      comments: 21,
    ),
    Post(
      author: 'SINAPRED',
      time: '6 Mayo',
      text:
          'Autoridades brindan informe sobre comportamientos y efectos de tormenta tropical Sara en Nicaragua.',
      image: 'assets/images/sample1.png',
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
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menú Principal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text("Configuración"),
              onTap: () {},
            ),
          ],
        ),
      ),

      // AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "SINAPRED",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/Avatar.png"),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Lista de noticias
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final p in posts) FeedCard(post: p),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
