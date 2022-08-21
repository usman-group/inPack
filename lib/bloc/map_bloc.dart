import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/markers/current_user_marker.dart';
import 'package:in_pack/markers/markers.dart';
import 'package:in_pack/utils/show_dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_event.dart';

part 'map_state.dart';

extension ToLatLng on Position {
  get latLng => LatLng(latitude, longitude);
}

class MapBloc extends Bloc<MapEvent, MapState> {

  MapBloc() : super(const MapState(<EquatableMarker>{}, null)) {
    on<MoveToCurrentPosition>((event, emit) {
      if (state.position != null) {
        event.mapController.move(state.position!.latLng, 16);
      }
    });
    on<RequestLocation>((event, emit) async {
      if (kIsWeb) {
        showInfoDialog(event.context,
            title: 'Геолокация',
            content: const Text(
                'Для веб-приложения не поддерживается геолокация (возможно пока что...)'));
        return;
      }
      final permission = await Permission.location.request();
      if (permission.isDenied) {
        emit(MapState(state.markers, state.position));
      }
      if (permission.isGranted) {
        final position = await Geolocator.getCurrentPosition();
        event.mapController.move(position.latLng, 16);
        final Set<EquatableMarker> markers = Set.from(state.markers);
        markers.add(CurrentUserMarker(position: position));
        emit(MapState(markers, position));
      }
    });
    on<AddMarker>((event, emit) {
      final Set<EquatableMarker> markers = Set.from(state.markers);
      markers.add(event.marker);
      emit(MapState(markers, state.position));
    });

    on<RemoveMarker>((event, emit) {
      final Set<EquatableMarker> markers = Set.from(state.markers);
      emit(MapState(markers..remove(event.marker), state.position));
    });
  }
}
