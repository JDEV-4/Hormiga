import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hormiga/main.dart';
import 'package:hormiga/data/repository/post_repository_impl.dart';
import 'package:hormiga/domain/usecases/get_posts_usecase.dart';
import 'package:hormiga/presentation/controllers/home_controller.dart';

void main() {
  testWidgets('HomePage carga posts', (WidgetTester tester) async {
    // Crear instancias necesarias
    final postRepository = PostRepositoryImpl();
    final getPostsUseCase = GetPostsUseCase(postRepository);

    // Construir el widget con providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => HomeController(getPostsUseCase),
          ),
        ],
        child: MaterialApp(
          home: MyApp(getPostsUseCase: getPostsUseCase), // <- sin const
        ),
      ),
    );

    // Esperar a que termine cualquier animación o async
    await tester.pumpAndSettle();

    // Comprobar que el título de la app se muestre
    expect(find.text('SINAPRED - La Hormiga'), findsOneWidget);

    // Comprobar que no hay indicador de carga
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
