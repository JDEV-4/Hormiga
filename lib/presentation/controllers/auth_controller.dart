// lib/presentation/controllers/auth_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hormiga/data/http/api_services.dart';

class AuthController {
  // Usamos la base URL centralizada de ApiServices
  final String baseUrl = ApiBaseUrls.apiBase;

  /// Intento de login. Retorna un map con {ok, token?, user?, message?}
  /// Ajusta los nombres de los campos ('NombreCompleto','Contrasena') según tu backend.
  Future<Map<String, dynamic>> login(String nombreCompleto, String contrasena) async {
    // Ajusta la ruta según tu backend: muchos proyectos usan /Usuario/autenticar
    final url = Uri.parse('$baseUrl/Usuario/autenticar');

    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'NombreCompleto': nombreCompleto,
          'Contrasena': contrasena,
        }),
      );

      final Map<String, dynamic> body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (resp.statusCode == 200) {
        // Suponemos body tiene token y user (ajusta si tu backend es distinto)
        final token = body['token'] as String?;
        final user = body['user'] as Map<String, dynamic>?;
        if (token != null) await _saveToken(token);
        return {'ok': true, 'token': token, 'user': user, 'message': body['message'] ?? ''};
      } else {
        final msg = body['message'] ?? 'Error en inicio de sesión: ${resp.statusCode}';
        return {'ok': false, 'message': msg};
      }
    } catch (e) {
      return {'ok': false, 'message': 'No se pudo conectar al servidor: $e'};
    }
  }

  /// Registro (ajusta endpoint y keys si tu backend usa otros nombres)
  Future<Map<String, dynamic>> register(String nombreCompleto, String contrasena, String telefono) async {
    final url = Uri.parse('$baseUrl/Usuario/registrar'); // ejemplo
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'NombreCompleto': nombreCompleto,
          'Contrasena': contrasena,
          'Telefono': telefono,
        }),
      );

      final Map<String, dynamic> body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return {'ok': true, 'message': body['message'] ?? 'Registrado correctamente'};
      } else {
        return {'ok': false, 'message': body['message'] ?? 'Error en el registro'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'No se pudo conectar al servidor: $e'};
    }
  }

  // Guarda token en SharedPreferences (clave 'auth_token')
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Recupera token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Elimina token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
