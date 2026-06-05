import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b_practical_rest_app/main.dart';
import 'package:lab8b_practical_rest_app/models/weather_report.dart';
import 'package:lab8b_practical_rest_app/services/weather_service.dart';

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherReport> fetchWeatherForCity(String city) async {
    return const WeatherReport(
      cityName: 'Hanoi',
      country: 'Vietnam',
      temperature: 28,
      apparentTemperature: 30,
      windSpeed: 8,
      humidity: 70,
      precipitation: 0,
      weatherCode: 1,
    );
  }
}

void main() {
  testWidgets('weather screen renders recommendation', (tester) async {
    await tester.pumpWidget(
      WeatherCompanionApp(repository: FakeWeatherRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Weather Companion'), findsOneWidget);
    expect(find.text('Nice weather for a walk.'), findsOneWidget);
  });
}
