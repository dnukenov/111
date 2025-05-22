import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    print("Login response: ${response.statusCode}");
    print("Login body: ${response.body}");

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      final data = json.decode(response.body);
      final token = data['token'];
      await prefs.setString('token', token);

      print("Saved username and token to SharedPreferences");
    } else {
      throw Exception("Login failed: ${response.body}");
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

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('token'); // Optional: clear the JWT token too
  }

}

