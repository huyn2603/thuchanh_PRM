import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';
import 'services/weather_service.dart';

void main() {
  runApp(WeatherCompanionApp(repository: OpenMeteoWeatherService()));
}

class WeatherCompanionApp extends StatelessWidget {
  const WeatherCompanionApp({super.key, required this.repository});

  final WeatherRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: WeatherScreen(repository: repository),
    );
  }
}
