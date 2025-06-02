import 'package:courierflow/Map/Map.dart';
import 'package:courierflow/Home/bloc/scanning_bloc.dart';
import 'package:courierflow/Data/Location.dart';
import 'package:courierflow/Utils/QrScannerOverlayShape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanningBloc scanningBloc = ScanningBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanningBloc(),
      child: BlocConsumer<ScanningBloc, ScanningState>(
        bloc: scanningBloc,
        listener: (context, state) {
          if (state is Added) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item added successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is StartNavigation) {
            // Navigate to the navigation page with the GPX file
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Map(gpxString: state.GPX,),
            ));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 173, 124),
              elevation: 10,
              title: Text(
                'Scan Page',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                // User profile icon with profile image
                FutureBuilder<Uint8List?>(
                  future: _getUserProfileImage(),
                  builder: (context, snapshot) {
                    // If we have the image data, show it in a CircleAvatar
                    if (snapshot.hasData && snapshot.data != null) {
                      return GestureDetector(
                        onTap: () => _showProfileDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: MemoryImage(snapshot.data!),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                    }
                    // Otherwise show the default icon
                    else {
                      return IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          _showProfileDialog(context);
                        },
                      );
                    }
                  },
                ),
                SizedBox(width: 8), // Add some spacing from the edge
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  // Scanner view with overlay
                  Positioned.fill(
                    child: MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                        facing: CameraFacing.back,
                        torchEnabled: false,
                      ),
                      onDetect: (capture) {
                        print('Scanner detected something');
                        final List<Barcode> barcodes = capture.barcodes;
                        print('Number of barcodes: ${barcodes.length}');
                        for (final barcode in barcodes) {
                          print('Barcode detected: ${barcode.rawValue}');
                          print('Barcode format: ${barcode.format}');
                          try {
                            final jsonData = jsonDecode(barcode.rawValue!);
                            print('Successfully parsed JSON: $jsonData');
                            scanningBloc
                                .add(ScanBarcode(Location.fromJson(jsonData)));
                          } catch (e) {
                            print('Error parsing barcode: $e');
                          }
                        }
                      },
                    ),
                  ),

                  // Scanner overlay shape
                  Positioned.fill(
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.transparent,
                        shape: QrScannerOverlayShape(
                          overlayColor: Color.fromARGB(255, 0, 126, 91),
                          borderColor: Color.fromARGB(255, 0, 173, 124),
                          borderRadius: 10,
                          borderLength: 20,
                          borderWidth: 10,
                        ),
                      ),
                    ),
                  ),

                  // Navigation button - fixed position with padding
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom +
                        20, // Add padding for safe area
                    left: 20,
                    right: 20,
                    child: Container(
                      margin: EdgeInsets
                          .zero, // Remove any margin that might cause overflow
                      child: ElevatedButton.icon(
                        onPressed: () {
                          scanningBloc.add(
                              Start(locations: scanningBloc.getLocations()));
                        },
                        icon: Icon(Icons.navigation, color: Colors.white),
                        label: Text(
                          "Start Navigation",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 173, 124),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          minimumSize: Size(double.infinity,
                              48), // Ensure button has a minimum height
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Profile dialog - existing code
  Future<void> _showProfileDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? 'No name available';
    final email = prefs.getString('email') ?? 'No email available';
    final vehicle = prefs.getString('vehicule') ?? 'No vehicle assigned';
    final imageBase64 = prefs.getString('profileImage');

    Uint8List? imageBytes;
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Courier Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageBytes != null) ...[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(imageBytes),
                  ),
                  SizedBox(height: 20),
                ] else ...[
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Name'),
                  subtitle: Text(name),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(email),
                ),
                ListTile(
                  leading: Icon(Icons.delivery_dining),
                  title: Text('Vehicle'),
                  subtitle: Text(vehicle),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  // Logout functionality - existing code
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Close the dialog
    Navigator.of(context).pop();

    // Navigate to login page and remove all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // New method to get user profile image as Uint8List
  Future<Uint8List?> _getUserProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imageBase64 = prefs.getString('profileImage');

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        return base64Decode(imageBase64);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    return null;
  }
}
