import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hormiga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7FAED6),
        scaffoldBackgroundColor: const Color(0xFFF1F5F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7FAED6),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
