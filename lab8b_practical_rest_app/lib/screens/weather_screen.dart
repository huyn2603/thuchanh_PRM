import 'package:flutter/material.dart';

import '../models/weather_report.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.repository});

  final WeatherRepository repository;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController(text: 'Hanoi');
  late Future<WeatherReport> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = widget.repository.fetchWeatherForCity('Hanoi');
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      _weatherFuture = widget.repository.fetchWeatherForCity(
        _cityController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Companion')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Should I go outside?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Search a city and get a decision-friendly forecast.'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<WeatherReport>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return _WeatherError(onRetry: _search);
                }

                final report = snapshot.data!;
                return WeatherReportCard(report: report);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherReportCard extends StatelessWidget {
  const WeatherReportCard({super.key, required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${report.cityName}, ${report.country}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  '${report.temperature.toStringAsFixed(1)} C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(report.description),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              report.recommendation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricTile(
              icon: Icons.thermostat,
              label: 'Feels like',
              value: '${report.apparentTemperature.toStringAsFixed(1)} C',
            ),
            _MetricTile(
              icon: Icons.air,
              label: 'Wind',
              value: '${report.windSpeed.toStringAsFixed(1)} km/h',
            ),
            _MetricTile(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${report.humidity}%',
            ),
            _MetricTile(
              icon: Icons.umbrella,
              label: 'Rain',
              value: '${report.precipitation.toStringAsFixed(1)} mm',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(label),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 12),
            const Text('Could not load weather data.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
