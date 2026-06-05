import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_report.dart';

abstract class WeatherRepository {
  Future<WeatherReport> fetchWeatherForCity(String city);
}

class OpenMeteoWeatherService implements WeatherRepository {
  OpenMeteoWeatherService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<WeatherReport> fetchWeatherForCity(String city) async {
    final cityQuery = city.trim().isEmpty ? 'Hanoi' : city.trim();
    final geoUri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': cityQuery,
      'count': '1',
      'language': 'en',
      'format': 'json',
    });

    final geoResponse = await _client
        .get(geoUri)
        .timeout(const Duration(seconds: 10));
    if (geoResponse.statusCode != 200) {
      throw Exception('Could not search city.');
    }

    final geoJson = json.decode(geoResponse.body) as Map<String, dynamic>;
    final results = geoJson['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) {
      throw Exception('City not found.');
    }

    final location = results.first as Map<String, dynamic>;
    final weatherUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location['latitude']}',
      'longitude': '${location['longitude']}',
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
    });

    final weatherResponse = await _client
        .get(weatherUri)
        .timeout(const Duration(seconds: 10));
    if (weatherResponse.statusCode != 200) {
      throw Exception('Could not load weather.');
    }

    final weatherJson =
        json.decode(weatherResponse.body) as Map<String, dynamic>;
    final current = weatherJson['current'] as Map<String, dynamic>;

    return WeatherReport(
      cityName: location['name'] as String,
      country: location['country'] as String? ?? '',
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: current['relative_humidity_2m'] as int,
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
    );
  }
}
