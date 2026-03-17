// ============================================================
// Feature 01: OpenStreetMap (flutter_map + geolocator)
// ============================================================
// Packages needed (already in pubspec.yaml):
//   flutter_map: ^7.0.2
//   latlong2: ^0.9.1
//   geolocator: ^13.0.1
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Default: Ho Chi Minh City
  LatLng _markerPos = const LatLng(10.7769, 106.7009);
  bool _hasMarker = false;
  bool _loadingLocation = false;
  final MapController _mapController = MapController();

  // ── Get GPS location ──────────────────────────────────────
  Future<void> _goToMyLocation() async {
    setState(() => _loadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng cấp quyền vị trí trong Settings')),
          );
        }
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final myLatLng = LatLng(pos.latitude, pos.longitude);

      _mapController.move(myLatLng, 16.0);
      setState(() {
        _markerPos = myLatLng;
        _hasMarker = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không lấy được vị trí: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  // ── Tap on map to place marker ─────────────────────────────
  void _onMapTap(TapPosition tapPos, LatLng point) {
    setState(() {
      _markerPos = point;
      _hasMarker = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tọa độ: ${point.latitude.toStringAsFixed(5)}, '
          '${point.longitude.toStringAsFixed(5)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ OpenStreetMap'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          // Clear marker
          if (_hasMarker)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Xoá marker',
              onPressed: () => setState(() => _hasMarker = false),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(10.7769, 106.7009),
              initialZoom: 13.0,
              onTap: _onMapTap,
            ),
            children: [
              // OpenStreetMap tiles (free, no API key)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter2026',
              ),
              // Marker layer
              if (_hasMarker)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _markerPos,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Coordinate card (bottom)
          if (_hasMarker)
            Positioned(
              bottom: 20,
              left: 16,
              right: 72,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Vị trí đã chọn',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Lat: ${_markerPos.latitude.toStringAsFixed(6)}'),
                      Text('Lng: ${_markerPos.longitude.toStringAsFixed(6)}'),
                    ],
                  ),
                ),
              ),
            ),

          // Hint text
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Nhấn vào bản đồ để đặt marker',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),

      // FAB: go to my location
      floatingActionButton: FloatingActionButton(
        onPressed: _loadingLocation ? null : _goToMyLocation,
        backgroundColor: Colors.green,
        tooltip: 'Vị trí của tôi',
        child: _loadingLocation
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
