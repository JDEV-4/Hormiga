import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {
  final String avatarAsset;
  const TopSearchBar({super.key, required this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Buscar', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(radius: 18, backgroundImage: AssetImage(avatarAsset)),
        ],
      ),
    );
  }
}
