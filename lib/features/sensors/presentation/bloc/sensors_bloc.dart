import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  SensorsBloc() : super(SensorsInitial()) {
    on<SensorsEvent>((event, emit) {});
  }
}
