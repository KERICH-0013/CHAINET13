import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Get current weather for a location (latitude, longitude)
  /// Tries real API first, falls back to mock data if fails
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true&timezone=auto',
    );

    try {
      if (kDebugMode) {
        print('🌤️ Fetching REAL weather data from: $url');
      }

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('⚠️ Weather API returned ${response.statusCode}, using mock data');
        }
        return _getMockCurrentWeather(latitude, longitude);
      }

      final data = json.decode(response.body);
      final current = data['current_weather'];

      // Try to get additional data from hourly if available
      int? humidity;
      double? pressure;

      try {
        // Fetch additional data for humidity and pressure
        final detailsUrl = Uri.parse(
            '$_baseUrl?latitude=$latitude&longitude=$longitude&hourly=relativehumidity_2m,pressure_msl&timezone=auto'
        );
        final detailsResponse = await http.get(detailsUrl).timeout(
          const Duration(seconds: 5),
        );

        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          if (detailsData['hourly'] != null) {
            if (detailsData['hourly']['relativehumidity_2m'] != null &&
                detailsData['hourly']['relativehumidity_2m'].isNotEmpty) {
              humidity = detailsData['hourly']['relativehumidity_2m'][0];
            }
            if (detailsData['hourly']['pressure_msl'] != null &&
                detailsData['hourly']['pressure_msl'].isNotEmpty) {
              pressure = detailsData['hourly']['pressure_msl'][0].toDouble();
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Could not fetch additional weather details: $e');
        }
      }

      if (kDebugMode) {
        print('✅ Got REAL weather data: ${current['temperature']}°C');
      }

      return {
        'temperature': current['temperature'],
        'temperature_unit': '°C',
        'humidity': humidity ?? 65,
        'humidity_unit': '%',
        'weather_code': current['weathercode'],
        'wind_speed': current['windspeed'],
        'wind_unit': 'km/h',
        'pressure': pressure?.toInt() ?? 1015,
        'pressure_unit': 'hPa',
        'is_real_data': true,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Weather API error: $e, using mock data');
      }
      return _getMockCurrentWeather(latitude, longitude);
    }
  }

  /// Get weather forecast for next 7 days
  Future<List<Map<String, dynamic>>> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=7',
    );

    try {
      if (kDebugMode) {
        print('📅 Fetching REAL forecast from: $url');
      }

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('⚠️ Forecast API returned ${response.statusCode}, using mock data');
        }
        return _getMockForecast();
      }

      final data = json.decode(response.body);
      final daily = data['daily'];
      final units = data['daily_units'];

      if (daily == null || daily['time'] == null) {
        throw Exception('No forecast data available');
      }

      List<Map<String, dynamic>> forecast = [];

      for (int i = 0; i < daily['time'].length; i++) {
        forecast.add({
          'date': daily['time'][i],
          'temp_max': daily['temperature_2m_max'][i],
          'temp_min': daily['temperature_2m_min'][i],
          'weather_code': daily['weathercode'][i],
          'temp_unit': units['temperature_2m_max'] ?? '°C',
          'is_real_data': true,
        });
      }

      if (kDebugMode) {
        print('✅ Got REAL forecast for ${forecast.length} days');
      }

      return forecast;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Forecast API error: $e, using mock data');
      }
      return _getMockForecast();
    }
  }

  /// MOCK DATA - Used only when API fails
  Map<String, dynamic> _getMockCurrentWeather(double latitude, double longitude) {
    // Generate realistic mock data based on location
    bool isKenya = latitude < 0 && latitude > -5 && longitude > 34 && longitude < 42;

    if (isKenya) {
      // Realistic Kenyan tea region weather
      return {
        'temperature': 22.5,
        'temperature_unit': '°C',
        'humidity': 72,
        'humidity_unit': '%',
        'weather_code': 2, // Partly cloudy
        'wind_speed': 12.0,
        'wind_unit': 'km/h',
        'pressure': 1015,
        'pressure_unit': 'hPa',
        'is_real_data': false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } else {
      // Generic mock data
      return {
        'temperature': 20.0,
        'temperature_unit': '°C',
        'humidity': 65,
        'humidity_unit': '%',
        'weather_code': 1,
        'wind_speed': 10.0,
        'wind_unit': 'km/h',
        'pressure': 1013,
        'pressure_unit': 'hPa',
        'is_real_data': false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// MOCK FORECAST - Used only when API fails
  List<Map<String, dynamic>> _getMockForecast() {
    final now = DateTime.now();
    final forecast = <Map<String, dynamic>>[];

    // Realistic tea region weather patterns
    final mockCodes = [0, 1, 2, 3, 2, 1, 0];
    final mockHighTemps = [24, 23, 22, 21, 23, 24, 25];
    final mockLowTemps = [14, 13, 12, 12, 13, 14, 15];

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      forecast.add({
        'date': date.toIso8601String(),
        'temp_max': mockHighTemps[i],
        'temp_min': mockLowTemps[i],
        'weather_code': mockCodes[i],
        'temp_unit': '°C',
        'is_real_data': false,
      });
    }

    return forecast;
  }

  /// Helper to convert weather code to description and icon
  static Map<String, dynamic> getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return {'description': 'Clear sky', 'icon': '☀️'};
      case 1:
        return {'description': 'Mainly clear', 'icon': '🌤️'};
      case 2:
        return {'description': 'Partly cloudy', 'icon': '⛅'};
      case 3:
        return {'description': 'Overcast', 'icon': '☁️'};
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
        return {'description': 'Rain showers', 'icon': '🌧️'};
      case 95:
      case 96:
      case 99:
        return {'description': 'Thunderstorm', 'icon': '⛈️'};
      default:
        return {'description': 'Variable', 'icon': '🌡️'};
    }
  }

  /// Get farming recommendation based on weather
  static String getFarmingTip(int weatherCode, double temperature, int humidity) {
    if (temperature > 28) {
      return '🔥 High temperature! Water tea plants in early morning or late evening.';
    } else if (temperature < 15) {
      return '❄️ Cool conditions - protect young tea shoots from frost.';
    } else if (humidity > 80) {
      return '💧 High humidity! Watch for fungal diseases like blister blight.';
    } else if (weatherCode == 61 || weatherCode == 63 || weatherCode == 65) {
      return '☔ Rain expected - good for tea growth, ensure proper drainage.';
    } else if (weatherCode == 0 || weatherCode == 1) {
      return '☀️ Sunny day - ideal for harvesting and drying tea leaves.';
    } else {
      return '🌱 Normal conditions - continue regular farm maintenance.';
    }
  }
}