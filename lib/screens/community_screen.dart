import 'package:flutter/material.dart';
import '../widgets/feed_card.dart';
import '../models/post.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(
        author: 'Roberto Javier',
        time: 'Hoy',
        text: 'Mi familia y yo salimos...',
        image: 'assets/images/sample1.png',
        likes: 231,
        comments: 21,
      ),
      Post(
        author: 'SINAPRED',
        time: '6 Mayo',
        text: 'Hicimos limpieza en la calle...',
        image: 'assets/images/sample1.png',
        likes: 356,
        comments: 21,
      ),
    ];

    return ListView(children: posts.map((p) => FeedCard(post: p)).toList());
  }
}
