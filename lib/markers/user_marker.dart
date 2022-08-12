import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/models/user.dart';
import 'package:in_pack/widgets/user_card.dart';
import 'package:latlong2/latlong.dart';

import 'markers.dart';

class UserMarker extends MarkerWithPopup {
  UserMarker({required this.position, required this.user})
      : super(
            builder: markerBuilder,
            point: LatLng(position.latitude, position.longitude));

  /// User from [FirebaseFirestore]
  final User user;

  /// User position from [FirebaseFirestore]
  final Position position;
  
  static const defaultUserImageUrl =
      'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album';


  @override
  String get categoryName => 'Стрелок';

  static Widget markerBuilder(BuildContext context) {
    return const Icon(
      Icons.panorama_fisheye_outlined,
      size: markerSize,
    );
  }

  @override
  Widget popupBuilder(BuildContext context) {
    return UserCard(user);
  }
}
