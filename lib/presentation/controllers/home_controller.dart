// lib/presentation/controllers/home_controller.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/get_posts_usecase.dart';

/// HomeController con persistencia local usando SharedPreferences.
/// Guarda la lista completa de posts como JSON en la clave 'home_posts_v1'.
class HomeController with ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;

  /// Usuario simulado (logueado)
  Map<String, dynamic> currentUser = {
    'id': 'user_1',
    'name': 'Juan Pérez',
    'username': 'juanperez',
    'avatar': 'assets/img/avatar.png',
  };

  /// Lista local de publicaciones
  List<Map<String, dynamic>> posts = [];

  static const String _kStorageKey = 'home_posts_v1';

  HomeController(this.getPostsUseCase) {
    // Cargar posts al inicializar (intenta desde SharedPreferences primero)
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      final loaded = await _loadPostsFromPrefs();
      if (loaded != null) {
        posts = loaded;
        notifyListeners();
        return;
      }

      final result = await _invokeGetPostsUseCase();

      if (result != null && result is List) {
        posts = result.map((e) {
          if (e is Map<String, dynamic>) return e;
          try {
            return {
              'title': (e as dynamic).title ?? '',
              'description': (e as dynamic).description ?? '',
              'imagePath': (e as dynamic).imageUrl ?? null,
              'createdAt': (e as dynamic).createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
              'author': (e as dynamic).author ?? currentUser,
            };
          } catch (_) {
            return {
              'title': e.toString(),
              'description': '',
              'imagePath': null,
              'createdAt': DateTime.now().toIso8601String(),
              'author': currentUser,
            };
          }
        }).toList();

        await _savePostsToPrefs(posts);
      } else {
        _loadSamplePostsIfEmpty();
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('Error en loadPosts(): $e\n$st');
      _loadSamplePostsIfEmpty();
      notifyListeners();
    }
  }

  Future<dynamic> _invokeGetPostsUseCase() async {
    try {
      return await getPostsUseCase();
    } catch (e) {
      try {
        // return await getPostsUseCase.execute();
        rethrow;
      } catch (_) {
        rethrow;
      }
    }
  }

  void _loadSamplePostsIfEmpty() {
    if (posts.isEmpty) {
      posts = [
        {
          'title': 'Simulacro de Sismo en la Universidad',
          'description': 'Participamos en el simulacro de sismo para mejorar la respuesta ante emergencias.',
          'imagePath': null,
          'createdAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
          'author': currentUser,
        },
        {
          'title': 'Limpieza del cauce en la comunidad',
          'description': 'Vecinos y voluntarios participaron en la jornada de limpieza para evitar inundaciones.',
          'imagePath': null,
          'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          'author': currentUser,
        },
      ];

      _savePostsToPrefs(posts);
    }
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    try {
      postData['author'] = postData['author'] ?? currentUser;

      if (postData['imagePath'] != null) {
        final file = File(postData['imagePath']);
        if (!await file.exists()) {
          debugPrint('⚠️ Imagen no encontrada en ${postData['imagePath']}');
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));

      posts.insert(0, {
        ...postData,
        'createdAt': postData['createdAt'] ?? DateTime.now().toIso8601String(),
      });

      await _savePostsToPrefs(posts);
      notifyListeners();
      debugPrint('✅ Publicación creada por ${postData['author']['name']}: ${postData['title']}');
    } catch (e) {
      debugPrint('❌ Error creando publicación: $e');
      rethrow;
    }
  }

  Future<void> deletePost(int index) async {
    if (index < 0 || index >= posts.length) return;
    posts.removeAt(index);
    await _savePostsToPrefs(posts);
    notifyListeners();
  }

  Future<void> updatePost(int index, Map<String, dynamic> updatedData) async {
    if (index < 0 || index >= posts.length) return;

    posts[index] = {
      ...posts[index],
      ...updatedData,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _savePostsToPrefs(posts);
    notifyListeners();
  }

  Future<void> clearPosts() async {
    posts.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStorageKey);
    notifyListeners();
  }

  List<Map<String, dynamic>> get sortedPosts {
    final sorted = [...posts];
    sorted.sort((a, b) {
      final dateA = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA);
    });
    return sorted;
  }

  Map<String, dynamic>? getPost(int index) {
    if (index < 0 || index >= posts.length) return null;
    return posts[index];
  }

  Future<void> _savePostsToPrefs(List<Map<String, dynamic>> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(list);
      await prefs.setString(_kStorageKey, jsonString);
    } catch (e) {
      debugPrint('Error guardando posts en SharedPreferences: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> _loadPostsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(_kStorageKey);
      if (s == null || s.isEmpty) return null;
      final decoded = jsonDecode(s);
      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e.map((k, v) => MapEntry(k.toString(), v)));
          } else {
            return {'title': e.toString()};
          }
        }).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error cargando posts desde SharedPreferences: $e');
      return null;
    }
  }

  void setCurrentUser(Map<String, dynamic> user) {
    currentUser = user;
    notifyListeners();
  }
}
