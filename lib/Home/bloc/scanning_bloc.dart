import 'package:bloc/bloc.dart';
import 'package:courierflow/Data/Location.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'scanning_event.dart';
part 'scanning_state.dart';

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  List<Location> locations = [];
  List<Location> getLocations() {
    return locations;
  }

  

  

  ScanningBloc() : super(ScanningInitial()) {
    on<ScanningEvent>((event, emit) {
      // Generic event handler
    });
    
    on<ScanBarcode>((event, emit) {
      try {
        locations.add(event.location);
        emit(Added());
      } catch (e) {
        print("Error in ScanBarcode event: $e");
        emit(Error());
      }
    });
    
    on<Start>((event, emit) async {
      try {
        // Get JWT token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final jwtToken = prefs.getString('token');
        
        if (jwtToken == null || jwtToken.isEmpty) {
          print("JWT token not found in SharedPreferences");
          emit(Error());
          return;
        }
        
        
        Position currentLocation = await determinePosition();
        double latitude = currentLocation.latitude;
        double longitude = currentLocation.longitude;
        
        // Create JSON structure for API request
        Map<String, dynamic> routeData = {
          "source": {"latitude": latitude, "longitude": longitude},
          "destinations": locations
              .map((location) => {
                    "latitude": location.latitude,
                    "longitude": location.longitude
                  })
              .toList()
        };

        // Convert to JSON string
        String jsonPayload = jsonEncode(routeData);
        
        // For debugging purposes
        print("Route JSON payload: $jsonPayload");

        try {
          // Make API call with JWT token in Authorization header
          final response = await http.post(
            Uri.parse('http://192.168.1.101:8080/route'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwtToken'
            },
            body: jsonPayload,
          );

          if (response.statusCode == 200) {
            print("Route API call successful");
            print("Response status: ${response.statusCode}");
            print("Response body length: ${response.body.length}");
            
            // Get GPX data from response
            String gpxData = response.body;
            emit(StartNavigation(GPX: gpxData));
          } else {
            // Handle error response
            print("Route API call failed with status: ${response.statusCode}");
            print("Response body: ${response.body}");
            emit(Error());
          }
        } catch (httpError) {
          print("HTTP error calling route API: $httpError");
          emit(Error());
        }
      } catch (e) {
        print("Error in Start event: $e");
        emit(Error());
      }
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
