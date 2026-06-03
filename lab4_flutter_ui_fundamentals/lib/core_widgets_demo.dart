import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 - Core Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Core Flutter Display Widgets',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Icon(Icons.flutter_dash, size: 72, color: Colors.teal),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/seed/flutter-lab4/900/420',
              height: 180,
              fit: BoxFit.cover,
              // The errorBuilder keeps the UI visible if the network is offline.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Text('Network image could not be loaded'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text('PRM393 Lab 4'),
              subtitle: Text('Card with ListTile, Icon, Text and spacing'),
              trailing: Icon(Icons.check_circle),
            ),
          ),
        ],
      ),
    );
  }
}
