import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseGoogleSignInApp());
}

class FirebaseGoogleSignInApp extends StatelessWidget {
  const FirebaseGoogleSignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Google Sign-In',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const FirebaseBootstrap(),
    );
  }
}

class FirebaseBootstrap extends StatelessWidget {
  const FirebaseBootstrap({super.key});

  static const FirebaseOptions demoOptions = FirebaseOptions(
    apiKey: 'replace-with-firebase-api-key',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'replace-with-firebase-project-id',
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(options: demoOptions),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const FirebaseSetupHelpScreen();
        }

        return const SignInScreen();
      },
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) return ProfileScreen(user: user);

        return Scaffold(
          appBar: AppBar(title: const Text('Google Sign-In')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle, size: 72),
                  const SizedBox(height: 12),
                  const Text('Sign in with Firebase Authentication'),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: Text(
                      _isLoading ? 'Signing in...' : 'Google Sign-In',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      setState(() {
        _error = 'Google Sign-In failed. Check Firebase configuration.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn.instance.signOut();
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 44,
            backgroundImage: user.photoURL == null
                ? null
                : NetworkImage(user.photoURL!),
            child: user.photoURL == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(height: 16),
          Text('Name: ${user.displayName ?? 'Unknown'}'),
          Text('Email: ${user.email ?? 'Unknown'}'),
          SelectableText('UID: ${user.uid}'),
        ],
      ),
    );
  }
}

class FirebaseSetupHelpScreen extends StatelessWidget {
  const FirebaseSetupHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase setup required')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Replace demo FirebaseOptions with your Firebase project values, '
          'configure SHA keys, enable Google provider, then run again.',
        ),
      ),
    );
  }
}
