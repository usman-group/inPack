import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/markers/current_user_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_event.dart';
part 'map_state.dart';

extension ToLatLng on Position {
  get latLng => LatLng(latitude, longitude);
}

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState([], null)) {
    on<MoveToCurrentPosition>((event, emit) {
      if (state.position != null) {
        event.mapController.move(state.position!.latLng, 16);
      }
    });

    on<RequestLocation>((event, emit) async {
      final permission = await Permission.location.request();
      if (permission.isDenied) {
        emit(MapState(state.markers, state.position));
      }
      if (permission.isGranted) {
        final position = await Geolocator.getCurrentPosition();
        event.mapController.move(position.latLng, 16);
        final List<Marker> markers = List.from(state.markers);
        markers.add(CurrentUserMarker(position: position));
        emit(MapState(markers, position));
      }
    });
    on<AddMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(markers..add(event.marker), state.position));
    });
    on<RemoveMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(markers..remove(event.marker), state.position));
    });
  }
}
