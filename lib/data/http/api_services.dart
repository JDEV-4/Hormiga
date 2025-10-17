// lib/data/http/api_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/domain_model.dart';
import '../../domain/models/type_registry.dart';

class ApiServices {
  // Ajusta según tu entorno:
  // - Emulador Android: http://10.0.2.2:5005/api
  // - iOS simulator / desktop: http://localhost:5005/api
  static const String baseUrl = 'https://integrador-bcg3epd6baajcqeg.eastus2-01.azurewebsites.net/api';

  ApiServices();

  /// Construye headers, añadiendo Authorization si hay token almacenado.
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<T>> getList<T extends DomainModel>({required T model}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}');
    final headers = await _getHeaders();
    final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded is List) {
        return decoded
            .map<T>((e) => TypeRegistry.create<T>(model.runtimeType.toString(), e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Se esperaba lista en getList: ${res.body}');
      }
    } else {
      throw Exception('GET ${model.getDomain()} failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<T> get<T extends DomainModel>({required T model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final headers = await _getHeaders();
    final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      return TypeRegistry.create<T>(model.runtimeType.toString(), decoded);
    } else {
      throw Exception('GET by id failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> put({required DomainModel model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final headers = await _getHeaders();
    final res = await http.put(uri, headers: headers, body: json.encode(model.toJson())).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('PUT failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<T?> post<T extends DomainModel>({required T model}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}');
    final headers = await _getHeaders();
    final res = await http.post(uri, headers: headers, body: json.encode(model.toJson())).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200 || res.statusCode == 201) {
      if (res.body.isEmpty) return null;
      final decoded = json.decode(res.body);
      if (decoded is Map<String, dynamic>) {
        return TypeRegistry.create<T>(model.runtimeType.toString(), decoded);
      } else {
        return null;
      }
    } else {
      throw Exception('POST failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> delete({required DomainModel model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final headers = await _getHeaders();
    final res = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 15));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    } else {
      throw Exception('DELETE failed: ${res.statusCode} ${res.body}');
    }
  }
}

/// Helper for base url reuse
class ApiBaseUrls {
  static const apiBase = ApiServices.baseUrl;
}
