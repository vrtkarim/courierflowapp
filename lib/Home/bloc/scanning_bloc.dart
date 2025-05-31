import 'package:bloc/bloc.dart';
import 'package:courierflow/Data/Location.dart';
import 'package:meta/meta.dart';

part 'scanning_event.dart';
part 'scanning_state.dart';

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  ScanningBloc() : super(ScanningInitial()) {
    on<ScanningEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
