import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/feed_card.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({super.key});

  final List<Post> posts = [
    Post(
      author: "Alcaldía de Jinotepe",
      time: "10 Mayo",
      text: "Jinotepe recibe un nuevo camión recolector de basura.",
      image: "assets/images/Hormiga.png",
      likes: 231,
      comments: 21,
    ),
    Post(
      author: "SINAPRED",
      time: "6 Julio",
      text:
          "Autoridades brindan informe sobre comportamiento y efectos de tormenta tropical Sara en Nicaragua.",
      image: "assets/images/Avatar.png",
      likes: 356,
      comments: 21,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return FeedCard(post: posts[index]);
        },
      ),
    );
  }
}
