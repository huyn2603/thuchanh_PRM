import 'package:flutter/material.dart';

void main() {
  runApp(const SignupApp());
}

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _isCheckingEmail = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String get _passwordStrength {
    final password = _passwordController.text;
    if (password.isEmpty) return 'Not started';
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasSymbol = RegExp(r'[^A-Za-z0-9]').hasMatch(password);
    final score = [
      password.length >= 8,
      hasDigit,
      hasLetter,
      hasSymbol,
    ].where((rule) => rule).length;
    if (score <= 2) return 'Weak';
    if (score == 3) return 'Medium';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text('Inline validation and keyboard flow are enabled.'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  onFieldSubmitted: (_) => _moveFocus(_emailFocus),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  onFieldSubmitted: (_) => _moveFocus(_passwordFocus),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _moveFocus(_confirmFocus),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _strengthValue()),
                const SizedBox(height: 6),
                Text('Password strength: $_passwordStrength'),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmController,
                  focusNode: _confirmFocus,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.verified_user),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                  title: const Text('I accept the Terms & Conditions'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _isCheckingEmail ? null : _submit,
                  child: _isCheckingEmail
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _moveFocus(FocusNode nextFocus) {
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Use at least 1 digit';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  double _strengthValue() {
    return switch (_passwordStrength) {
      'Weak' => 0.33,
      'Medium' => 0.66,
      'Strong' => 1,
      _ => 0,
    };
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms first.')),
      );
      return;
    }

    setState(() {
      _isCheckingEmail = true;
    });

    // Simulates an async backend email availability check.
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isCheckingEmail = false;
    });

    if (_emailController.text.trim().toLowerCase().startsWith('taken')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already taken.')),
      );
      return;
    }

    _formKey.currentState?.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Welcome, ${_nameController.text.trim()}!')),
    );
  }
}
