import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  String? _storedUsername;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedUsername = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_storedUsername == null) ...[
              TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _isLoginMode ? AuthService.login(_usernameController.text, _passwordController.text) : AuthService.register(_usernameController.text, _passwordController.text);
                },
                child: Text(_isLoginMode ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(_isLoginMode ? 'Don\'t have an account? Register' : 'Already have an account? Login'),
              ),
            ] else ...[
              const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/avatar.png')),
              Text(_storedUsername!, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: AuthService.logout, child: const Text('Logout')),
            ],
          ],
        ),
      ),
    );
  }
}
