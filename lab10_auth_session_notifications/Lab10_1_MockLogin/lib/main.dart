import 'package:flutter/material.dart';

void main() {
  runApp(const MockLoginApp());
}

class MockLoginApp extends StatelessWidget {
  const MockLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.1 Mock Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MockAuthService {
  Future<String> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (email == 'student@prm.com' && password == 'Password123') {
      return 'mock-token-123';
    }
    throw Exception('Invalid email or password');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'student@prm.com');
  final _passwordController = TextEditingController(text: 'Password123');
  final _authService = MockAuthService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Login')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Lab 10.1', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Valid: student@prm.com / Password123'),
            const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => HomeScreen(token: token)),
      );
    } catch (error) {
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Login success\nToken: $token')),
    );
  }
}
