import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(post.avatarUrl),
        title: Text(post.title),
        subtitle: Text(post.content),
      ),
    );
  }
}
