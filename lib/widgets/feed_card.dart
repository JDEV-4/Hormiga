import 'package:flutter/material.dart';
import '../models/post.dart';

class FeedCard extends StatelessWidget {
  final Post post;
  const FeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/Avatar.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(post.text),
            if (post.image.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  post.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 20),
                    const SizedBox(width: 6),
                    Text(post.likes.toString()),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 20),
                    const SizedBox(width: 6),
                    Text(post.comments.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
