import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: currentIndex == 0 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            color: currentIndex == 1 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(1),
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.group),
            color: currentIndex == 2 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            color: currentIndex == 3 ? Colors.blue : Colors.grey,
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
