import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// Model class for SignInRequest
class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  Map<String, String> toJson() => {
        'email': email,
        'password': password,
      };
}

// Model class for UserAuthenticationResponse
class UserAuthenticationResponse {
  final String token;
  final String email;
  final String vehicule;
  final String name;
  final List<int>?
      image; // Note: This should be List<int> or String based on your API

  UserAuthenticationResponse({
    required this.token,
    required this.email,
    required this.vehicule,
    required this.name,
    this.image,
  });

  factory UserAuthenticationResponse.fromJson(Map<String, dynamic> json) {
    // Handle the image field correctly for PostgreSQL bytea type
    List<int>? imageData;

    if (json['image'] != null) {
      try {
        if (json['image'] is String) {
          // Case 1: Base64 encoded string
          imageData = base64Decode(json['image']);
        } else if (json['image'] is List) {
          // Case 2: JSON array of integers
          imageData = List<int>.from(json['image']);
        } else {
          // Log the unexpected type for debugging
          print('Unexpected image data type: ${json['image'].runtimeType}');
          print('Image data: ${json['image']}');
        }
      } catch (e) {
        // Handle parsing errors without crashing
        print('Error processing image data: $e');
      }
    }

    return UserAuthenticationResponse(
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      vehicule: json['vehicule'] ?? '',
      name: json['name'] ?? '',
      image: imageData,
    );
  }
}

// Auth states

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Update with your actual API URL
  final String baseUrl = 'http://192.168.1.101:8080';

  UserAuthenticationResponse? _userResponse;

  UserAuthenticationResponse? get userResponse => _userResponse;

  AuthBloc() : super(AuthInitial()) {
    // Check if user is already logged in during initialization
    _checkIfUserIsLoggedIn();

    on<Login>((event, emit) async {
      emit(Loading());
      try {
        if (event.email.isNotEmpty && event.password.isNotEmpty) {
          // Create the sign-in request
          final signInRequest = SignInRequest(
            email: event.email,
            password: event.password,
          );

          // Make API call to Spring Boot endpoint
          final response = await http.post(
            Uri.parse('$baseUrl/signin'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(signInRequest.toJson()),
          );

          if (response.statusCode == 200) {
            try {
              // Parse the response
              final data = jsonDecode(response.body);

              // Debug the structure and types
              print('Response data structure:');
              data.forEach((key, value) {
                print('$key: ${value?.runtimeType}');
              });

              if (data['image'] != null) {
                print('Image data type: ${data['image'].runtimeType}');
                if (data['image'] is String) {
                  print(
                      'Image is String, length: ${(data['image'] as String).length}');
                } else if (data['image'] is List) {
                  print(
                      'Image is List, length: ${(data['image'] as List).length}');
                }
              }

              _userResponse = UserAuthenticationResponse.fromJson(data);

              // Save token/user data to local storage
              await _saveUserData(_userResponse!);
              print("user saved with success");
              emit(
                  Logged()); // logged is emited but not reached i dont know how to solve it
            } catch (parseError) {
              print('Error parsing response: $parseError');
              print('Response body: ${response.body}');
              emit(NotLogged(message: 'Error parsing response: $parseError'));
              emit(AuthInitial());
            }
          } else {
            // Handle error
            final errorMessage = response.statusCode == 401
                ? 'Invalid email or password'
                : 'Login failed. Please try again later. Status: ${response.statusCode}';

            print('Login failed: $errorMessage');
            print('Response body: ${response.body}');
            emit(NotLogged(message: errorMessage));
            emit(AuthInitial());
          }
        } else {
          emit(NotLogged(message: 'Email and password cannot be empty'));
          emit(AuthInitial());
        }
      } catch (e) {
        print('Network error: $e');
        emit(NotLogged(message: 'Network error: $e'));
      }
    });

    on<Logout>((event, emit) async {
      await _clearUserData();
      emit(AuthInitial());
    });

    on<CheckAuthStatus>((event, emit) async {
      final isLoggedIn = await _isLoggedIn();
      if (isLoggedIn) {
        emit(Logged());
      } else {
        emit(AuthInitial());
      }
    });
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    final isLoggedIn = await _isLoggedIn();
    if (isLoggedIn) {
      add(CheckAuthStatus());
    }
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> _saveUserData(UserAuthenticationResponse user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token);
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name);
    await prefs.setString('vehicule', user.vehicule);

    // Save the profile image if available
    if (user.image != null && user.image!.isNotEmpty) {
      try {
        final imageBase64 = base64Encode(user.image!);
        await prefs.setString('profileImage', imageBase64);
      } catch (e) {
        print('Error saving profile image: $e');
      }
    }

    await prefs.setBool('isLoggedIn', true);
    print("user saved successfully");
    return;
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
    await prefs.remove('vehicule');
    await prefs.setBool('isLoggedIn', false);
  }
}
