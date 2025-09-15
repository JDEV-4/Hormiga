import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  final String avatarAsset;
  final VoidCallback onNotificationTap; //SE ACCIONA LA CAMPANITA
  const TopAppBar({
    super.key,
    required this.avatarAsset,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Texto en lugar de buscador
            const Text(
              "SINAPRED",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Row(
              children: [
                // Campanita de notificación
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: onNotificationTap,
                ),

                // Avatar de usuario
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      avatarAsset,
                      fit: BoxFit.cover,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
