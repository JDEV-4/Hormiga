import 'package:flutter/material.dart';
import '../widgets/top_search_bar.dart';
import '../widgets/feed_card.dart';
import '../models/post.dart';
import '../widgets/bottom_nav_custom.dart';
import 'menu_screen.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  final List<Post> posts = [
    Post(
      author: 'Alcaldía de Jinotepe',
      time: '10 Mayo',
      text: 'Jinotepe recibe un nuevo camión recolector de basura.',
      image: 'assets/images/sample1.png',
      likes: 231,
      comments: 21,
    ),
    Post(
      author: 'SINAPRED',
      time: '6 Mayo',
      text:
          'Autoridades brindan informe sobre comportamientos y efectos de tormenta tropical Sara en Nicaragua.',
      image: 'assets/images/sample1.png',
      likes: 356,
      comments: 21,
    ),
  ];

  void _onNavTap(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_tabIndex == 0) {
      content = ListView(
        children: [
          const SizedBox(height: 8),
          for (final p in posts) FeedCard(post: p),
          const SizedBox(height: 80),
        ],
      );
    } else if (_tabIndex == 1) {
      content = const MenuScreen();
    } else if (_tabIndex == 2) {
      content = const CommunityScreen();
    } else {
      content = const Center(child: Text('Estadísticas (próximo)'));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: TopSearchBar(avatarAsset: 'assets/images/Avatar.png'),
      ),
      body: content,
      bottomNavigationBar: BottomNavCustom(
        currentIndex: _tabIndex,
        onTap: _onNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
