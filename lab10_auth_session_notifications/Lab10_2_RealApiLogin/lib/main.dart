import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RealApiLoginApp());
}

class RealApiLoginApp extends StatelessWidget {
  const RealApiLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.2 API Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class AuthResult {
  const AuthResult({required this.username, required this.accessToken});

  final String username;
  final String accessToken;

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      username: json['username'] as String,
      accessToken: json['accessToken'] as String,
    );
  }
}

class DummyJsonAuthService {
  Future<AuthResult> login(String username, String password) async {
    final response = await http.post(
      Uri.https('dummyjson.com', '/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed: ${response.body}');
    }

    return AuthResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  final _service = DummyJsonAuthService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real API Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'DummyJSON Auth',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Text('Test account: emilys / emilyspass'),
          const SizedBox(height: 18),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _isLoading ? null : _login,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Login with API'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _service.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => HomeScreen(result: result)),
      );
    } catch (error) {
      setState(() => _error = 'Login failed. Check credentials/network.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.result});

  final AuthResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${result.username}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText('Access token:\n${result.accessToken}'),
      ),
    );
  }
}
