import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception("Login failed");
    }
  }

  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception("Registration failed");
    }
  }

  static Future<void> logout() async {}
}
