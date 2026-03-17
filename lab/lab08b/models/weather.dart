// Lab 8B – Weather Model
// Maps response from Open-Meteo API (free, no API key required)

class CurrentWeather {
  final double temperature;
  final double windspeed;
  final int humidity;
  final int weatherCode;

  const CurrentWeather({
    required this.temperature,
    required this.windspeed,
    required this.humidity,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return CurrentWeather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windspeed: (current['windspeed_10m'] as num).toDouble(),
      humidity: (current['relativehumidity_2m'] as num).toInt(),
      weatherCode: (current['weathercode'] as num).toInt(),
    );
  }

  // WMO weather code → description
  String get description {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 2) return 'Partly cloudy';
    if (weatherCode == 3) return 'Overcast';
    if (weatherCode <= 49) return 'Foggy';
    if (weatherCode <= 59) return 'Drizzle';
    if (weatherCode <= 69) return 'Rain';
    if (weatherCode <= 79) return 'Snow';
    if (weatherCode <= 84) return 'Rain showers';
    if (weatherCode <= 94) return 'Thunderstorm';
    return 'Thunderstorm with hail';
  }

  // Smart recommendation based on conditions
  String get umbrellaAdvice {
    if (weatherCode >= 50 && weatherCode <= 99) return '☂️ Take an umbrella!';
    return '✅ No umbrella needed';
  }

  String get outdoorAdvice {
    if (temperature > 38) return '🥵 Too hot for outdoor activities';
    if (temperature < 10) return '🥶 Too cold – dress warmly!';
    if (weatherCode >= 50) return '🌧️ Not ideal for outdoor activities';
    return '🌿 Nice weather for a walk!';
  }

  String get weatherEmoji {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 2) return '⛅';
    if (weatherCode == 3) return '☁️';
    if (weatherCode <= 49) return '🌫️';
    if (weatherCode <= 69) return '🌧️';
    if (weatherCode <= 79) return '❄️';
    if (weatherCode <= 84) return '🌦️';
    return '⛈️';
  }
}

// ── City data (for selecting city) ──────────────────────────────────────────

class City {
  final String name;
  final double latitude;
  final double longitude;

  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

const List<City> popularCities = [
  City(name: 'Ho Chi Minh City', latitude: 10.8231, longitude: 106.6297),
  City(name: 'Hanoi', latitude: 21.0285, longitude: 105.8542),
  City(name: 'Da Nang', latitude: 16.0471, longitude: 108.2068),
  City(name: 'Tokyo', latitude: 35.6762, longitude: 139.6503),
  City(name: 'London', latitude: 51.5074, longitude: -0.1278),
  City(name: 'New York', latitude: 40.7128, longitude: -74.0060),
  City(name: 'Singapore', latitude: 1.3521, longitude: 103.8198),
  City(name: 'Sydney', latitude: -33.8688, longitude: 151.2093),
];
