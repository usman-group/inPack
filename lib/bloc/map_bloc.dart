import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState([], null)) {
    on<RequestLocation>((event, emit) async {
      final permission = await Permission.location.request();
      if (permission.isDenied){
        emit(MapState(state.markers, null));
      }
      if (permission.isGranted){
        emit(MapState(state.markers, await Geolocator.getCurrentPosition()));
      }
    });
    on<AddMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(markers..add(event.marker), null));
    });
    on<RemoveMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(markers..remove(event.marker), null));
    });
  }
}
