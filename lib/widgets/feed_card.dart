import 'package:flutter/material.dart';
import '../models/post.dart';

class FeedCard extends StatefulWidget {
  final Post post;

  const FeedCard({super.key, required this.post});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late int likeCount;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
        isLiked = false;
      } else {
        likeCount++;
        isLiked = true;
      }
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Estilos por tipo de usuario
    Color borderColor;
    IconData? badgeIcon;

    switch (widget.post.type) {
      case "official": // SINAPRED
        borderColor = Colors.redAccent;
        badgeIcon = Icons.campaign;
        break;
      case "municipality": // Alcaldías
        borderColor = Colors.blueAccent;
        badgeIcon = Icons.account_balance;
        break;
      default: // ciudadano normal
        borderColor = Colors.grey.shade300;
        badgeIcon = null;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Autor y fecha
          ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    widget.post.avatarUrl,
                  ), // 🔹 dinámico
                ),
                if (badgeIcon != null)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: borderColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Icon(badgeIcon, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),

            title: Text(
              widget.post.author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.post.time),
          ),

          // Texto
          if (widget.post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.post.text,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),

          // Imagen
          if (widget.post.image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.post.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),

          const SizedBox(height: 8),

          // Acciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLike,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Icon(
                      isLiked
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                      color: isLiked ? Colors.blueAccent : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text("$likeCount"),

                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text("${widget.post.comments}"),

                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.blueAccent),
                  onPressed: () {
                    // lógica de compartir
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
