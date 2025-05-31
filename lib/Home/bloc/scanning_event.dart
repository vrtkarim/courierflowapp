part of 'scanning_bloc.dart';

@immutable
sealed class ScanningEvent {}
class ScanBarcode extends ScanningEvent {
  final Location location;
  ScanBarcode(this.location);
}