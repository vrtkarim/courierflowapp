// filepath: c:\src\flutter\flutter_projects\courierflow\lib\Map\Map.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  final String gpxString;
  final bool isUrl;

  const Map({
    super.key,
    required this.gpxString,
    this.isUrl = false,
  });

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  List<LatLng> routePoints = [];
  bool isLoading = true;
  String? errorMessage;
  LatLng? currentUserLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadGpxData();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentUserLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update when user moves 10 meters
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        currentUserLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<void> _loadGpxData() async {
    try {
      String gpxData = widget.gpxString;
      final gpx = GpxReader().fromString(gpxData);
      final points = <LatLng>[];
      for (var track in gpx.trks) {
        for (var segment in track.trksegs) {
          for (var point in segment.trkpts) {
            points.add(LatLng(point.lat!, point.lon!));
          }
        }
      }

      if (points.isEmpty) {
        for (var route in gpx.rtes) {
          for (var point in route.rtepts) {
            points.add(LatLng(point.lat!, point.lon!));
          }
        }
      }

      // Extract from waypoints if both tracks and routes are empty
      if (points.isEmpty) {
        for (var waypoint in gpx.wpts) {
          points.add(LatLng(waypoint.lat!, waypoint.lon!));
        }
      }

      setState(() {
        routePoints = points;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading GPX data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route Map')),
        body: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (routePoints.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route Map')),
        body: const Center(
          child: Text('No route points found in the GPX data'),
        ),
      );
    }

    // Calculate the center point of the route
    final centerLat =
        routePoints.map((p) => p.latitude).reduce((a, b) => a + b) /
            routePoints.length;
    final centerLng =
        routePoints.map((p) => p.longitude).reduce((a, b) => a + b) /
            routePoints.length;
    final center = currentUserLocation ?? LatLng(centerLat, centerLng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (currentUserLocation != null) {
                _mapController.move(currentUserLocation!, 15.0);
              }
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(centerLat, centerLng),
          
          maxZoom: 18.0,
          minZoom: 10.0,
          // Disable rotation
          
        ),
        children: [
          // Base map layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.courierflow',
            subdomains: const ['a', 'b', 'c'],
          ),
          // Route polyline
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          // Markers layer
          MarkerLayer(
            markers: [
              // Start marker
              Marker(
                point: routePoints.first,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 30,
                ),
              ),
              // End marker
              Marker(
                point: routePoints.last,
                child: const Icon(
                  Icons.flag,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              // Current user location marker
              if (currentUserLocation != null)
                Marker(
                  point: currentUserLocation!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar:
          currentUserLocation != null ? _buildBottomPanel() : null,
    );
  }

  Widget _buildBottomPanel() {
    

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.directions, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Follow the blue route',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.social_distance, color: Colors.blue),
              const SizedBox(width: 8),
              
            ],
          ),
        ],
      ),
    );
  }

  
}
