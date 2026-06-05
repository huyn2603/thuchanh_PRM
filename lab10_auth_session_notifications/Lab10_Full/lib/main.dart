import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab10FullApp());
}

class Lab10FullApp extends StatelessWidget {
  const Lab10FullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10 Full',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SessionService {
  static const _tokenKey = 'token';
  static const _nameKey = 'name';

  Future<void> save(String token, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_nameKey, name);
  }

  Future<({String? token, String? name})> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (token: prefs.getString(_tokenKey), name: prefs.getString(_nameKey));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> loginSuccess(String name) async {
    const android = AndroidNotificationDetails(
      'auth_channel',
      'Authentication',
      channelDescription: 'Login and session notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.show(
      10,
      'Welcome $name',
      'Login successful and session saved.',
      const NotificationDetails(android: android),
    );
  }
}

class ApiAuthService {
  Future<({String token, String name})> login(
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
    if (response.statusCode != 200) throw Exception('Login failed');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (
      token: data['accessToken'] as String,
      name: '${data['firstName']} ${data['lastName']}',
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _session = SessionService();
  final _notifications = NotificationService();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await _notifications.init();
    final saved = await _session.load();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => saved.token == null
            ? const LoginScreen()
            : HomeScreen(name: saved.name ?? 'User', token: saved.token!),
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
  final _api = ApiAuthService();
  final _session = SessionService();
  final _notifications = NotificationService();
  bool _isLoading = false;
  String? _error;

  static const FirebaseOptions demoOptions = FirebaseOptions(
    apiKey: 'replace-with-firebase-api-key',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'replace-with-firebase-project-id',
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10 Full Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Authentication Hub',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Text('DummyJSON: emilys / emilyspass'),
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
          FilledButton.icon(
            onPressed: _isLoading ? null : _loginWithApi,
            icon: const Icon(Icons.login),
            label: Text(_isLoading ? 'Signing in...' : 'Real API Login'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _loginWithGoogle,
            icon: const Icon(Icons.account_circle),
            label: const Text('Firebase Google Sign-In'),
          ),
        ],
      ),
    );
  }

  Future<void> _loginWithApi() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _api.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      await _finishLogin(result.token, result.name);
    } catch (_) {
      setState(() => _error = 'API login failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: demoOptions);
      }
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await _finishLogin(
        await authResult.user?.getIdToken() ?? 'firebase-token',
        authResult.user?.displayName ?? 'Google User',
      );
    } catch (_) {
      setState(() {
        _error = 'Google Sign-In needs real Firebase configuration.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _finishLogin(String token, String name) async {
    await _session.save(token, name);
    await _notifications.loginSuccess(name);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(name: name, token: token),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.name, required this.token});

  final String name;
  final String token;

  @override
  Widget build(BuildContext context) {
    final session = SessionService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $name'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await session.clear();
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn.instance.signOut();
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Auto-login is enabled. Restart the app to test it.'),
          const SizedBox(height: 12),
          SelectableText('Session token:\n$token'),
        ],
      ),
    );
  }
}
