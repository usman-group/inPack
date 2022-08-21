import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'markers.dart';

class CurrentUserMarker extends MarkerWithPopup {
  CurrentUserMarker({required this.position})
      : super(
            builder: markerBuilder,
            point: LatLng(
              position.latitude,
              position.longitude,
            ),
            height: 40,
            width: 40);

  /// Current user position
  final Position position;

  /// User from [FirebaseChatCore]
  // final User user;

  @override
  String get categoryName => 'Стрелок';

  static Widget markerBuilder(BuildContext context) {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundColor: Colors.brown,
        radius: 13.5,
        child: Icon(
          Icons.accessible_rounded,
          color: Colors.brown,
          size: 27,
        ),
      ),
    );
  }

  @override
  Widget popupBuilder(BuildContext context) {
    // TODO: add popup for current user
    return Container();
  }

  @override
  List<Object?> get props => const ['Текущий пользователь'];
}
