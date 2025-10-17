// lib/domain/models/user.dart
import 'package:hormiga/domain/models/domain_model.dart';

class User extends DomainModel {
  final int usuarioId;
  final String nombreCompleto;
  final String correo;
  final List<String> roles;

  User({
    required this.usuarioId,
    required this.nombreCompleto,
    required this.correo,
    required this.roles,
  });

  /// Endpoint/Domain name que usa ApiServices
  @override
  String getDomain() => 'usuarios';

  /// Convierte a JSON para enviar al backend
  @override
  Map<String, dynamic> toJson() => {
        'usuarioId': usuarioId,
        'nombreCompleto': nombreCompleto,
        'correo': correo,
        'roles': roles,
      };

  /// Factory constructor estático para crear User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      usuarioId: json['usuarioId'] is int
          ? json['usuarioId'] as int
          : int.tryParse('${json['usuarioId']}') ?? 0,
      nombreCompleto: json['nombreCompleto']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      roles: (json['roles'] is List)
          ? List<String>.from((json['roles'] as List).map((e) => e.toString()))
          : <String>[],
    );
  }

  /// Implementación requerida por DomainModel (puede delegar al factory)
  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  /// Utilidad: crea una instancia vacía / placeholder
  factory User.empty() => User(usuarioId: 0, nombreCompleto: '', correo: '', roles: []);
}
