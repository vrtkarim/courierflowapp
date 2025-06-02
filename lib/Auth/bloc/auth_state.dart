part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class Loading extends AuthState{}

class Logged extends AuthState {}

class NotLogged extends AuthState {
  final String message;
  NotLogged({required this.message});
}
