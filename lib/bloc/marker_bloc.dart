import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'marker_event.dart';
part 'marker_state.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  MarkerBloc() : super(MarkerInitial()) {
    on<MarkerEvent>((event, emit) {});
  }
}
