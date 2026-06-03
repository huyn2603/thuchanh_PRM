import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _volume = 40;
  bool _notificationsEnabled = true;
  String _selectedPlan = 'Basic';
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) {
      return;
    }

    // setState updates the label after the DatePicker closes.
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'No date selected'
        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 - Input Controls')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Slider value: ${_volume.round()}'),
          Slider(
            min: 0,
            max: 100,
            divisions: 10,
            label: _volume.round().toString(),
            value: _volume,
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(height: 24),
          const Text('Choose a plan'),
          RadioGroup<String>(
            groupValue: _selectedPlan,
            onChanged: _changePlan,
            child: const Column(
              children: [
                RadioListTile<String>(title: Text('Basic'), value: 'Basic'),
                RadioListTile<String>(
                  title: Text('Standard'),
                  value: 'Standard',
                ),
                RadioListTile<String>(title: Text('Premium'), value: 'Premium'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month),
            label: const Text('Pick a date'),
          ),
          const SizedBox(height: 12),
          Text('Selected plan: $_selectedPlan'),
          Text('Selected date: $dateText'),
        ],
      ),
    );
  }

  void _changePlan(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedPlan = value;
    });
  }
}
