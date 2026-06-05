import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotificationDemoApp());
}

class NotificationDemoApp extends StatelessWidget {
  const NotificationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.5 Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showLoginSuccessNotification() async {
    const android = AndroidNotificationDetails(
      'auth_channel',
      'Authentication',
      channelDescription: 'Notifications for authentication actions',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);
    await _plugin.show(
      1,
      'Login successful',
      'Your session is ready.',
      details,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _service = NotificationService();
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _service.init();
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_active, size: 72),
              const SizedBox(height: 12),
              const Text('Tap the button to trigger a system notification.'),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _isReady
                    ? () => _service.showLoginSuccessNotification()
                    : null,
                icon: const Icon(Icons.send),
                label: Text(_isReady ? 'Show notification' : 'Initializing...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
