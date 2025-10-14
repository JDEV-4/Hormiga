import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';

class HomeController extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;

  HomeController(this.getPostsUseCase);

  bool isLoading = false;
  String? errorMessage;
  List<PostEntity> posts = [];

  Future<void> loadPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      posts = await getPostsUseCase();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
