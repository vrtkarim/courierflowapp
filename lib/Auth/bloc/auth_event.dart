part of 'auth_bloc.dart';

abstract class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class Logout extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
