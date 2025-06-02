// filepath: c:\src\flutter\flutter_projects\courierflow\lib\Map\Map.dart
import 'package:courierflow/Data/Location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Map extends StatefulWidget {
  final String gpxString;

  const Map({super.key, required this.gpxString});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late Gpx _gpx;
  List<LatLng> _routePoints = [];
  LatLng? _currentLocation;
  List<LatLng> _destinationPoints = [];
  Timer? _locationTimer;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _parseGpx();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _parseGpx() {
    // Parse GPX string
    _gpx = GpxReader().fromString(widget.gpxString);

    // Extract route points from track segments
    if (_gpx.trks.isNotEmpty && _gpx.trks.first.trksegs.isNotEmpty) {
      final trkpts = _gpx.trks.first.trksegs.first.trkpts;
      _routePoints = trkpts.map((trkpt) => LatLng(trkpt.lat!, trkpt.lon!)).toList();
    }

    // Extract waypoints (destinations)
    if (_gpx.wpts.isNotEmpty) {
      _destinationPoints = _gpx.wpts.map((wpt) => LatLng(wpt.lat!, wpt.lon!)).toList();
    }
  }

  void _startLocationTracking() async {
    // Get initial location
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }

    // Start periodic location updates
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });

        // Center map on current location if it's the first update
        if (timer.tick == 1 && _currentLocation != null) {
          _mapController.move(_currentLocation!, 15);
        }
      } catch (e) {
        print('Error updating location: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation', style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 0, 173, 124),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? 
              (_destinationPoints.isNotEmpty ? _destinationPoints.first : LatLng(0, 0)),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.courierflow',
          ),
          // Draw the route line
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                color: Color.fromARGB(255, 255, 98, 0),
                strokeWidth: 4.0,
              ),
            ],
          ),
          // Custom markers for current location and destinations
          MarkerLayer(
            markers: [
              // Current location marker with delivery.png
              if (_currentLocation != null)
                Marker(
                  point: _currentLocation!,
                  width: 60,
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(
                        'img/delivery.png',
                        width: 40,
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          'You',

                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 126, 91),
                            
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Destination markers with package.png (skip the first one as it's the source)
              for (int i = 1; i < _destinationPoints.length; i++)
                Marker(
                  point: _destinationPoints[i],
                  width: 60,
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(
                        'img/package.png',
                        width: 40,
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          'Stop ${i}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Color.fromARGB(255, 0, 173, 124),
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 15);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
