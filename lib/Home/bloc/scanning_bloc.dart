import 'package:bloc/bloc.dart';
import 'package:courierflow/Data/Location.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'scanning_event.dart';
part 'scanning_state.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  List<Location> locations = [];
  List<Location> getLocations() {
    return locations;
  }

  ScanningBloc() : super(ScanningInitial()) {
    on<ScanningEvent>((event, emit) {
      
    });
    on<ScanBarcode>((event, emit) {
      try {
        locations.add(event.location);
        emit(Added());
      } catch (e) {
        emit(Error());
      }
    });
    on<Start>((event, emit) async {
      try {
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
        print(jsonPayload);

        // For debugging purposes
        print("Route JSON payload: $jsonPayload");

        // TODO: make API call to get GPX file using the jsonPayload
        // Example API call would be:
         final response = await http.post(
           Uri.parse('https://192.168.1.101:8080/route'),
           headers: {'Content-Type': 'application/json'},
          body: jsonPayload,
         );

        // For now, using a placeholder URL
        String GPX = response.body; // Replace with actual URL
        emit(StartNavigation(GPX: GPX));
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
