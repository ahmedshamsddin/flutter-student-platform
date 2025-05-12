import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:student_platform/di/injection_container.dart';
import 'package:student_platform/features/student/attempt_status/attempt_status_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
  

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  static const _userIdKey = 'user_id';


  final String baseUrl = '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}';// or your IP

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: _tokenKey, value: data['token']);
      await _storage.write(key: _roleKey, value: data['role']);
      await _storage.write(key: _userIdKey, value: data['id'].toString());
      await sl<AttemptStatusCubit>().loadFromBackend(data['id']);
      return true;
    }

    return false;
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<String?> getRole() => _storage.read(key: _roleKey);
  Future<int?> getUserId() async {
  	final id = await _storage.read(key: _userIdKey);
  	return id != null ? int.tryParse(id) : null;
  }


  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
