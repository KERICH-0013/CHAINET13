import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Get current weather for a location (latitude, longitude)
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true&timezone=auto',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      final current = data['current_weather'];

      return {
        'temperature': current['temperature'],
        'temperature_unit': '°C', // Open‑Meteo always returns °C
        'humidity': null,          // humidity not in current_weather; you'd need additional fields
        'humidity_unit': '%',
        'weather_code': current['weathercode'],
        'wind_speed': current['windspeed'],
        'wind_unit': 'km/h',
        'pressure': null,
        'pressure_unit': 'hPa',
      };
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Get weather forecast for next 7 days (with daily min/max and weather code)
  Future<List<Map<String, dynamic>>> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=7',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      final daily = data['daily'];
      final units = data['daily_units'];

      List<Map<String, dynamic>> forecast = [];

      for (int i = 0; i < daily['time'].length; i++) {
        forecast.add({
          'date': daily['time'][i],
          'temp_max': daily['temperature_2m_max'][i],
          'temp_min': daily['temperature_2m_min'][i],
          'weather_code': daily['weathercode'][i],
          'temp_unit': units['temperature_2m_max'],
        });
      }

      return forecast;
    } catch (e) {
      throw Exception('Failed to fetch forecast: $e');
    }
  }

  /// Helper to convert weather code to description and icon
  static Map<String, dynamic> getWeatherInfo(int code) {
    // WMO Weather interpretation codes (same as before)
    switch (code) {
      case 0:
        return {'description': 'Clear sky', 'icon': '☀️'};
      case 1:
      case 2:
      case 3:
        return {'description': 'Partly cloudy', 'icon': '⛅'};
      case 45:
      case 48:
        return {'description': 'Foggy', 'icon': '🌫️'};
      case 51:
      case 53:
      case 55:
        return {'description': 'Drizzle', 'icon': '🌧️'};
      case 61:
      case 63:
      case 65:
        return {'description': 'Rain', 'icon': '☔'};
      case 71:
      case 73:
      case 75:
        return {'description': 'Snow', 'icon': '❄️'};
      case 80:
      case 81:
      case 82:
        return {'description': 'Rain showers', 'icon': '☔'};
      case 95:
      case 96:
      case 99:
        return {'description': 'Thunderstorm', 'icon': '⛈️'};
      default:
        return {'description': 'Unknown', 'icon': '🌡️'};
    }
  }
}