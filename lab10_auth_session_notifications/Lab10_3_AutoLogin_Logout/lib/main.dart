import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AutoLoginApp());
}

class AutoLoginApp extends StatelessWidget {
  const AutoLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.3 Auto Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SessionService {
  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'username';

  Future<void> saveSession(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  Future<({String? token, String? username})> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      token: prefs.getString(_tokenKey),
      username: prefs.getString(_usernameKey),
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }
}

class ApiAuthService {
  Future<({String token, String username})> login(
    String username,
    String password,
  ) async {
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
      throw Exception('Invalid credentials');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (
      token: data['accessToken'] as String,
      username: data['username'] as String,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final session = await _sessionService.loadSession();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => session.token == null
            ? const LoginScreen()
            : HomeScreen(
                username: session.username ?? 'User',
                token: session.token!,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
  final _authService = ApiAuthService();
  final _sessionService = SessionService();
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
      appBar: AppBar(title: const Text('Auto Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Login once, then restart the app to skip this screen.'),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _login,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Login and Save Session'),
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
      final result = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      await _sessionService.saveSession(result.token, result.username);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              HomeScreen(username: result.username, token: result.token),
        ),
      );
    } catch (_) {
      setState(() => _error = 'Login failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.username, required this.token});

  final String username;
  final String token;

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $username'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await sessionService.clearSession();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText('Persisted token:\n$token'),
      ),
    );
  }
}
