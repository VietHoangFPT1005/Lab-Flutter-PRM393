// Lab 8B – WeatherService (Service Layer)
// Uses Open-Meteo API: free, no API key required

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<CurrentWeather> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,weathercode,windspeed_10m,relativehumidity_2m',
      'timezone': 'auto',
    });

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CurrentWeather.fromJson(json);
    } else {
      throw Exception(
          'Failed to fetch weather. Status: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
