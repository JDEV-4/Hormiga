import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<PostEntity>> getPosts() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      PostEntity(
        title: 'Post de prueba',
        author: 'Juan Pérez',
        date: '14/10/2025',
        content: 'Contenido del post',
        avatarUrl: 'https://www.pngarts.com/files/5/User-Avatar-PNG-Transparent-Image.png',
        imageUrl: 'https://via.placeholder.com/150',
        location: 'Nicaragua',
        likes: 10,
        comments: 2,
      ),
    ];
  }
}
