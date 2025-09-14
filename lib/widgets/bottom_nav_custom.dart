import 'package:flutter/material.dart';

class BottomNavCustom extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => onTap(0),
              icon: const Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () => onTap(1),
              icon: const Icon(Icons.list_alt, color: Colors.white),
            ),
            const SizedBox(width: 40),
            IconButton(
              onPressed: () => onTap(2),
              icon: const Icon(Icons.people, color: Colors.white),
            ),
            IconButton(
              onPressed: () => onTap(3),
              icon: const Icon(Icons.bar_chart, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
