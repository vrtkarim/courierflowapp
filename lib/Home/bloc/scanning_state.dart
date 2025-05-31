part of 'scanning_bloc.dart';

@immutable
sealed class ScanningState {}

final class ScanningInitial extends ScanningState {}

class Added extends ScanningState {}

class Error extends ScanningState {}

class StartNavigation extends ScanningState {
  final String GPX;
  StartNavigation({required this.GPX});
}
