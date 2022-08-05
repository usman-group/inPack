import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/markers/user_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'map_event.dart';
part 'map_state.dart';

extension ToLatLng on Position {
  get latLng => LatLng(latitude, longitude);
}

class MapBloc extends Bloc<MapEvent, MapState> {
  /// Get current [User] from [FirebaseFirestore] that used in [FirebaseChatCore]
  Future<types.User> get currentFirestoreUser async {
    types.User currentUser;
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDoc.data()!;
    data.addAll({'id': FirebaseAuth.instance.currentUser!.uid});
    currentUser = types.User.fromJson(data);
    return currentUser;
  }

  MapBloc(MapController mapController)
      : super(MapState(const [], null, mapController)) {
    on<RequestLocation>((event, emit) async {
      final permission = await Permission.location.request();
      if (permission.isDenied) {
        emit(MapState(state.markers, state.location, mapController));
      }
      if (permission.isGranted) {
        final location = await Geolocator.getCurrentPosition();
        mapController.move(location.latLng, 16);
        final List<Marker> markers = List.from(state.markers);
        markers.add(CurrentUserMarker(
            position: location, user: await currentFirestoreUser));
        emit(MapState(markers, location, mapController));
      }
    });
    on<AddMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(markers..add(event.marker), state.location, mapController));
    });
    on<RemoveMarker>((event, emit) {
      final List<Marker> markers = List.from(state.markers);
      emit(MapState(
          markers..remove(event.marker), state.location, mapController));
    });
  }
}
