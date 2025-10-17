import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de estructura limpia
import 'presentation/controllers/home_controller.dart' as home_ctrl;
import 'presentation/controllers/educational_module_controller.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'data/repository/post_repository_impl.dart';

// Páginas principales
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/splash_page.dart';

void main() {
  // Inicializa las dependencias
  final postRepository = PostRepositoryImpl();
  final getPostsUseCase = GetPostsUseCase(postRepository);

  runApp(MyApp(getPostsUseCase: getPostsUseCase));
}

class MyApp extends StatelessWidget {
  final GetPostsUseCase getPostsUseCase;

  const MyApp({super.key, required this.getPostsUseCase});

  // Color institucional centralizado
  static const Color azul = Color(0xFF234A68);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // Alias para evitar conflictos con HomePage
          create: (_) => home_ctrl.HomeController(getPostsUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => EducationalModuleController(),
        ),
      ],
      child: MaterialApp(
        title: 'La Hormiga',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: azul,
          colorScheme: ColorScheme.fromSeed(seedColor: azul, primary: azul),
          useMaterial3: false,

          appBarTheme: const AppBarTheme(
            backgroundColor: azul,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: azul.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: azul,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: azul, width: 2),
            ),
          ),

          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.06),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),

          scaffoldBackgroundColor: const Color(0xFFF4F6F8),

          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: Colors.black87,
                displayColor: Colors.black87,
              ),
        ),

        // ✅ Registro de rutas nombradas
        routes: {
          '/': (ctx) => const SplashPage(),
          '/login': (ctx) => const LoginPage(),
          '/home_page': (ctx) => const HomePage(),
        },

        // Ruta inicial
        initialRoute: '/',
      ),
    );
  }
}
