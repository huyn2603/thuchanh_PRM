class WeatherReport {
  const WeatherReport({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.apparentTemperature,
    required this.windSpeed,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
  });

  final String cityName;
  final String country;
  final double temperature;
  final double apparentTemperature;
  final double windSpeed;
  final int humidity;
  final double precipitation;
  final int weatherCode;

  String get description {
    if ([0].contains(weatherCode)) return 'Clear sky';
    if ([1, 2, 3].contains(weatherCode)) return 'Partly cloudy';
    if ([45, 48].contains(weatherCode)) return 'Foggy';
    if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(weatherCode)) {
      return 'Rain expected';
    }
    if ([95, 96, 99].contains(weatherCode)) return 'Thunderstorm';
    return 'Mixed conditions';
  }

  String get recommendation {
    if (precipitation > 0 || description.contains('Rain')) {
      return 'Take an umbrella before going out.';
    }
    if (temperature >= 34) {
      return 'Too hot for outdoor sports. Drink water and stay shaded.';
    }
    if (temperature >= 20 && windSpeed < 25) {
      return 'Nice weather for a walk.';
    }
    return 'Check the sky and dress comfortably.';
  }
}
