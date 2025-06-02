import 'package:courierflow/Auth/Auth.dart';
import 'package:courierflow/Auth/bloc/auth_bloc.dart';
import 'package:courierflow/Home/ScanPage.dart';
import 'package:courierflow/Map/Map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Start the app with the appropriate initial route
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthStatus()),
      child: MaterialApp(
        title: 'Courier Flow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: isLoggedIn ? '/home' : '/login',
        routes: {
          '/login': (context) => const AuthenticationPage(),
          '/home': (context) => const ScanPage(),
          '/map': (context) => Map(gpxString: "",),
        },
      ),
    );
  }
}
