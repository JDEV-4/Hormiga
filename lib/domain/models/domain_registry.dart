abstract class DomainModel {
  /// Convierte el modelo a JSON para enviar al API
  Map<String, dynamic> toJson();

  /// Devuelve el 'domain' o ruta del endpoint (ej: "Categoria", "Usuario")
  String getDomain();

  /// Nombre de tipo (opcional, para TypeRegistry)
  String getTypeName() => runtimeType.toString();

   // Debe devolver el objeto listo para ser codificado a JSO
}