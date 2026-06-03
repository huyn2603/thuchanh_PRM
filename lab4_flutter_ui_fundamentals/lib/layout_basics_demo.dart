import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  static const List<String> movies = [
    'The Flutter Journey',
    'Stateful Nights',
    'Layout Mission',
    'Widget Kingdom',
    'Debug Mode',
    'Material Future',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 - Layout Basics')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home Screen Layout',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.movie),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Column, Row, Padding, SizedBox and ListView',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Recommended movies'),
          ),
          const SizedBox(height: 8),
          Expanded(
            // Expanded gives ListView a bounded height inside Column.
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    tileColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(movies[index]),
                    subtitle: const Text('Built with ListView.builder'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
