import 'package:flutter/material.dart';

class DebugFixesDemo extends StatefulWidget {
  const DebugFixesDemo({super.key});

  @override
  State<DebugFixesDemo> createState() => _DebugFixesDemoState();
}

class _DebugFixesDemoState extends State<DebugFixesDemo> {
  int _counter = 0;
  DateTime? _selectedDate;

  Future<void> _showPickerFromValidContext() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'No DatePicker result yet'
        : 'Picked ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 - Debug Fixes')),
      body: SingleChildScrollView(
        // SingleChildScrollView prevents overflow on small screens.
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Common UI Errors Fixed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const _FixNote(
              title: '1. ListView inside Column',
              description:
                  'Fix: wrap ListView with Expanded or give it a height.',
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: Column(
                children: [
                  const Text('Fixed ListView sample'),
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('Item A')),
                        ListTile(title: Text('Item B')),
                        ListTile(title: Text('Item C')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const _FixNote(
              title: '2. Overflow on small screens',
              description: 'Fix: wrap the content with SingleChildScrollView.',
            ),
            const _FixNote(
              title: '3. State not updating',
              description: 'Fix: update values inside setState().',
            ),
            Row(
              children: [
                Text('Counter: $_counter'),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _FixNote(
              title: '4. DatePicker context error',
              description:
                  'Fix: call showDatePicker from a valid widget context.',
            ),
            FilledButton.icon(
              onPressed: _showPickerFromValidContext,
              icon: const Icon(Icons.event),
              label: const Text('Open DatePicker'),
            ),
            const SizedBox(height: 8),
            Text(dateText),
          ],
        ),
      ),
    );
  }
}

class _FixNote extends StatelessWidget {
  const _FixNote({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}
