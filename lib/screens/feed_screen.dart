import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/feed_card.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({super.key});

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
      avatarUrl: "assets/images/Alcaldia.jpg", // 🔹 avatar del autor
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
    // 🔹 separar oficiales de los demás
    List<Post> officialPosts = posts
        .where((p) => p.type == "official")
        .toList();
    List<Post> otherPosts = posts.where((p) => p.type != "official").toList();

    return SafeArea(
      child: ListView(
        children: [
          // 🔴 Oficiales siempre arriba
          for (final p in officialPosts) FeedCard(post: p),

          const Divider(),

          // 🔹 El resto de usuarios
          for (final p in otherPosts) FeedCard(post: p),
        ],
      ),
    );
  }
}
