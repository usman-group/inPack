import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'markers.dart';

class UserMarker extends MarkerWithPopup {
  UserMarker({required this.position, required this.user})
      : super(
            builder: markerBuilder,
            point: LatLng(position.latitude, position.longitude));

  /// User from [FirebaseChatCore]
  final types.User user;

  /// Current user position
  final Position position;
  static const defaultUserImageUrl =
      'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album';

  @override
  String get categoryName => 'Стрелок';

  static Widget markerBuilder(BuildContext context) {
    return const Icon(
      Icons.arrow_downward,
      color: Colors.blueAccent,
      size: markerSize,
    );
  }

  @override
  Widget popupBuilder() {
    return SizedBox(
      height: 250,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Категория: $categoryName',
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'SF', fontWeight: FontWeight.bold),
            ),
            Image.network(
              user.imageUrl ?? defaultUserImageUrl,
              height: 180,
            ),
            user.firstName == null
                ? const Text(
                    'Нет имени',
                    style: emptyFieldTextStyle,
                  )
                : Text(user.firstName!,
                    style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
