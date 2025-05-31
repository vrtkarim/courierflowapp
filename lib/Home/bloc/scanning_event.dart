part of 'scanning_bloc.dart';

class ScanningEvent {}


class ScanBarcode extends ScanningEvent {
  final Location location;
  ScanBarcode(this.location);
}
class Start extends ScanningEvent {
   List<Location> locations;
  Start({required this.locations});

}