// lib/domain/models/type_registry.dart
import 'user.dart'; // Asegúrate de que la ruta relativa sea correcta (este archivo está en same folder)

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class TypeRegistry {
  static final Map<String, FromJson<dynamic>> _creators = {};

  static void register<T>(String typeName, FromJson<T> creator) {
    _creators[typeName] = creator;
  }

  static T create<T>(String typeName, Map<String, dynamic> json) {
    final creator = _creators[typeName];
    if (creator == null) {
      throw Exception('No creator registered for $typeName. Asegúrate de llamar a registerModels() en main.dart.');
    }
    return creator(json) as T;
  }
}

/// Llama a este método en main() para registrar modelos
void registerModels() {
  // --- MODELOS REGISTRADOS ---
  TypeRegistry.register<User>('User', (json) => User.fromJson(json));
}
