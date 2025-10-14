import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/home_controller.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'data/repository/post_repository_impl.dart';
import 'presentation/pages/home_page.dart';

void main() {
  final postRepository = PostRepositoryImpl();
  final getPostsUseCase = GetPostsUseCase(postRepository);

  runApp(MyApp(getPostsUseCase: getPostsUseCase));
}

class MyApp extends StatelessWidget {
  final GetPostsUseCase getPostsUseCase;

  const MyApp({super.key, required this.getPostsUseCase});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeController(getPostsUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'La Hormiga',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
