import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';

class FeedCard extends StatelessWidget {
  final Post post;

  const FeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Encabezado con avatar y autor
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(post.avatarUrl),
              radius: 24,
            ),
            title: Text(
              post.author,
              style: GoogleFonts.sourceSans3(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              post.time,
              style: GoogleFonts.sourceSans3(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Imagen del post
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          ),

          //Texto del post
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              post.text,
              style: GoogleFonts.sourceSans3(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),

          // Reacciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${post.likes}',
                  style: GoogleFonts.sourceSans3(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${post.comments}',
                  style: GoogleFonts.sourceSans3(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
