// lib/presentation/controllers/user_controller.dart
import 'package:hormiga/data/http/api_services.dart';
import 'package:hormiga/domain/models/user.dart';

/// Controlador para operaciones CRUD sobre usuarios.
/// - Por defecto usa el endpoint 'usuarios' (puedes cambiarlo).
/// - Inyecta ApiServices para facilitar pruebas y compatibilidad con distintas firmas.
class UserController {
  final ApiServices _api;
  final String endpoint;

  /// Si no pasas `api`, se crea una instancia por defecto de ApiServices.
  UserController({ApiServices? api, this.endpoint = 'usuarios'}) : _api = api ?? ApiServices();

  /// Obtiene todo el listado de usuarios.
  Future<List<User>> getAllUsers() async {
    try {
      final List<User> list = await _api.getList<User>(
        model: User(usuarioId: 0, nombreCompleto: '', correo: '', roles: []),
      );
      return list;
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  /// Obtiene un usuario por su id. Retorna null si no existe.
  Future<User?> getById(int id) async {
    try {
      final User user = await _api.get<User>(
        model: User(usuarioId: 0, nombreCompleto: '', correo: '', roles: []),
        id: id.toString(),
      );
      return user;
    } catch (e) {
      throw Exception('Error al obtener usuario (id=$id): $e');
    }
  }

  /// Crea un usuario en el backend.
  Future<User?> createUser(User user) async {
    try {
      final created = await _api.post<User>(model: user);
      return created;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  /// Actualiza un usuario por id.
  Future<void> updateUser(int id, User user) async {
    try {
      await _api.put(model: user, id: id.toString());
    } catch (e) {
      throw Exception('Error al actualizar usuario (id=$id): $e');
    }
  }

  /// Elimina un usuario por id.
  Future<void> deleteUser(int id) async {
    try {
      await _api.delete(model: userPlaceholder(id), id: id.toString());
    } catch (e) {
      throw Exception('Error al eliminar usuario (id=$id): $e');
    }
  }

  /// Helper: crea un usuario placeholder cuando la firma de delete requiere un model.
  User userPlaceholder(int id) => User(usuarioId: id, nombreCompleto: '', correo: '', roles: []);
}
