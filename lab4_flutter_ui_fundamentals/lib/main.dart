import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'debug_fixes_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'scaffold_theme_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  ThemeMode _themeMode = ThemeMode.light;

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  void _updateTheme(bool isDarkMode) {
    // setState redraws MaterialApp so ThemeMode changes immediately.
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter UI',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: LabHomeScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _updateTheme,
      ),
    );
  }
}

class LabHomeScreen extends StatelessWidget {
  const LabHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final exercises = <_ExerciseItem>[
      const _ExerciseItem(
        title: 'Exercise 1',
        subtitle: 'Core Widgets',
        icon: Icons.widgets,
        screen: CoreWidgetsDemo(),
      ),
      const _ExerciseItem(
        title: 'Exercise 2',
        subtitle: 'Input Controls',
        icon: Icons.tune,
        screen: InputControlsDemo(),
      ),
      const _ExerciseItem(
        title: 'Exercise 3',
        subtitle: 'Layout Basics',
        icon: Icons.view_agenda,
        screen: LayoutBasicsDemo(),
      ),
      _ExerciseItem(
        title: 'Exercise 4',
        subtitle: 'Scaffold, FAB and Theme',
        icon: Icons.phone_android,
        screen: ScaffoldThemeDemo(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
        ),
      ),
      const _ExerciseItem(
        title: 'Exercise 5',
        subtitle: 'Debug and Fix UI Errors',
        icon: Icons.bug_report,
        screen: DebugFixesDemo(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Flutter UI Fundamentals'),
        actions: [Switch(value: isDarkMode, onChanged: onThemeChanged)],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            child: ListTile(
              leading: Icon(exercise.icon),
              title: Text(exercise.title),
              subtitle: Text(exercise.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => exercise.screen),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: exercises.length,
      ),
    );
  }
}

class _ExerciseItem {
  const _ExerciseItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;
}
