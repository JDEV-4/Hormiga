// lib/data/http/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hormiga/data/http/api_services.dart';

/// Servicio de autenticación que maneja el inicio/cierre de sesión y la gestión del token JWT.
class AuthService {
  /// Usa la base URL definida en ApiServices
  final String baseUrl = ApiBaseUrls.apiBase;

  /// Almacenamiento seguro para guardar el token JWT
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Realiza el inicio de sesión enviando credenciales al backend.
  /// Retorna `true` si el inicio de sesión fue exitoso, y guarda el token JWT en almacenamiento seguro.
  Future<bool> login(String nombreCompleto, String contrasena) async {
    try {
      final uri = Uri.parse('$baseUrl/Usuario/autenticar');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NombreCompleto': nombreCompleto,
          'Contrasena': contrasena,
        }),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final token = data['token'];

        if (token != null) {
          // Guarda el token en almacenamiento seguro
          await _storage.write(key: 'jwt', value: token);
          return true;
        }
      }

      return false;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Cierra la sesión eliminando el token JWT almacenado.
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'jwt');
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Obtiene el token JWT almacenado (si existe).
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'jwt');
    } catch (e) {
      throw Exception('Error al obtener token: $e');
    }
  }

  /// Decodifica el token JWT para obtener los datos del usuario.
  Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
