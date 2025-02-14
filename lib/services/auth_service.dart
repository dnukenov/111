import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> login(String username, String password) async {
    await http.post(Uri.parse('http://127.0.0.1:5000/login'), body: json.encode({'username': username, 'password': password}));
  }

  static Future<void> register(String username, String password) async {
    await http.post(Uri.parse('http://127.0.0.1:5000/register'), body: json.encode({'username': username, 'password': password}));
  }

  static Future<void> logout() async {}
}
