import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/widgets/user_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'markers.dart';

class CurrentUserMarker extends MarkerWithPopup {
  CurrentUserMarker({required this.position, required this.user})
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
  final types.User user;

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
}
