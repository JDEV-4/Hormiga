// lib/domain/models/domain_model.dart

/// Clase base abstracta que todos los modelos de dominio deben extender.
///
/// Define los métodos esenciales que el sistema usa para
/// comunicarse con la API:
/// - [getDomain]: devuelve el nombre del dominio o endpoint REST.
/// - [toJson]: convierte el modelo a Map<String, dynamic> para enviar al servidor.
/// - [fromJson]: convierte datos JSON en una instancia del modelo.
abstract class DomainModel {
  /// Retorna el nombre del dominio o endpoint del modelo.
  /// Ejemplo:
  ///   - Para usuarios → 'usuarios'
  ///   - Para publicaciones → 'posts'
  String getDomain();

  /// Convierte el modelo en un mapa JSON para enviarlo en las peticiones.
  Map<String, dynamic> toJson();

  /// Convierte datos JSON en una instancia del modelo correspondiente.
  /// Este método puede ser implementado o manejarse mediante [TypeRegistry].
  DomainModel fromJson(Map<String, dynamic> json);
}
