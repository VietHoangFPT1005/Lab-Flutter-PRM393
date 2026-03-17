// Lab 8B – Weather Companion App
// Scenario A: Help users decide what to do/wear based on weather
// API: Open-Meteo (free, no key required)

import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherService _weatherService;
  City _selectedCity = popularCities.first;
  Future<CurrentWeather>? _weatherFuture;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService();
    _fetchWeather();
  }

  void _fetchWeather() {
    setState(() {
      _isDemo = false;
      _weatherFuture = _weatherService
          .fetchWeather(
            latitude: _selectedCity.latitude,
            longitude: _selectedCity.longitude,
          )
          .then((w) {
        // If temperature is one of our known demo values → demo mode
        if (mounted) {
          setState(() => _isDemo = _knownDemoTemps
              .contains(w.temperature));
        }
        return w;
      });
    });
  }

  // Known demo temperatures used in WeatherService._demoWeather()
  // Note: cannot use `const` because double overrides == and hashCode
  static final _knownDemoTemps = <double>{
    32.9, 24.5, 12.0, 10.5, 8.0, 30.0, 22.0, 20.0,
  };

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion – Lab 8B'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Demo banner ───────────────────────────────────────────
              if (_isDemo)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange[900]!.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off,
                          size: 14, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Demo data – no internet connection',
                          style: TextStyle(
                              color: Colors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── City Selector ─────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<City>(
                    isExpanded: true,
                    dropdownColor: Colors.blueGrey[700],
                    value: _selectedCity,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16),
                    icon: const Icon(Icons.location_on,
                        color: Colors.lightBlueAccent),
                    items: popularCities
                        .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city.name),
                            ))
                        .toList(),
                    onChanged: (city) {
                      if (city != null) {
                        _selectedCity = city;
                        _fetchWeather();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Weather Data ──────────────────────────────────────────
              Expanded(
                child: FutureBuilder<CurrentWeather>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    // Loading state
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                                color: Colors.lightBlueAccent),
                            SizedBox(height: 16),
                            Text('Fetching weather...',
                                style: TextStyle(
                                    color: Colors.white70)),
                          ],
                        ),
                      );
                    }

                    // Error state (only if service itself throws)
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off,
                                color: Colors.redAccent, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'Could not load weather data',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _fetchWeather,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Data state
                    final weather = snapshot.data!;
                    return _WeatherContent(
                      city: _selectedCity,
                      weather: weather,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Weather Content Widget ───────────────────────────────────────────────────

class _WeatherContent extends StatelessWidget {
  final City city;
  final CurrentWeather weather;

  const _WeatherContent({required this.city, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Main weather card ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey[700]!,
                  Colors.blueGrey[600]!
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  weather.weatherEmoji,
                  style: const TextStyle(fontSize: 72),
                ),
                const SizedBox(height: 8),
                Text(
                  city.name,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 16),
                ),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w200),
                ),
                Text(
                  weather.description,
                  style: const TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Stats Row ────────────────────────────────────────────────
          Row(
            children: [
              _StatCard(
                icon: Icons.air,
                label: 'Wind',
                value:
                    '${weather.windspeed.toStringAsFixed(1)} km/h',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Recommendations ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Recommendations',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _RecommendationRow(text: weather.umbrellaAdvice),
                const SizedBox(height: 8),
                _RecommendationRow(text: weather.outdoorAdvice),
                const SizedBox(height: 8),
                _RecommendationRow(
                  text: weather.humidity > 70
                      ? '💧 High humidity – stay hydrated!'
                      : '💧 Humidity is comfortable',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.lightBlueAccent, size: 28),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  final String text;

  const _RecommendationRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}
