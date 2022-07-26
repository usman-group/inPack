import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

abstract class MarkerWithPopup extends Marker {
  MarkerWithPopup(
      {required super.point,
      required super.builder,
      super.anchorPos,
      super.height,
      super.key,
      super.rotate,
      super.rotateAlignment,
      super.rotateOrigin,
      super.width});

  /// for build popup on map
  Widget popupBuilder();
  String get categoryName;
}

class SmokeRoomMarker extends MarkerWithPopup {
  static const double markerSize = 30;
  SmokeRoomMarker({
    required super.point,
    required this.name,
    this.imageUrl,
    this.description,
  }) : super(height: markerSize, width: markerSize, builder: markerBuilder);
  final String name;
  final String? imageUrl;
  final String? description;
  static Widget markerBuilder(BuildContext context) {
    return const Icon(
      Icons.smoking_rooms_rounded,
      color: Colors.brown,
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
            Text(categoryName),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'SF', fontWeight: FontWeight.bold),
            ),
            Image.network(
              imageUrl ??
                  'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album',
              height: 180,
            ),
            Text(description ??
                'Нет описания, но вы можете его добавить ;);))%;(№), только пока нельзя соре'),
          ],
        ),
      ),
    );
  }

  @override
  String get categoryName => 'Курилка';
}

class UserMarker extends MarkerWithPopup {
  UserMarker({required this.position, required this.user})
      : super(
            builder: markerBuilder,
            point: LatLng(position.latitude, position.longitude));
  final types.User user;
  final Position position;

  LatLng get userPoint => LatLng(position.latitude, position.longitude);

  static Widget markerBuilder(BuildContext context) {
    return const Icon(
      CupertinoIcons.person_fill,
      color: Colors.amberAccent,
      size: 30,
    );
  }

  @override
  String get categoryName => 'Усманчик';

  @override
  Widget popupBuilder() {
    return SizedBox(
      height: 250,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Text(categoryName),
            Text(
              categoryName,
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'SF', fontWeight: FontWeight.bold),
            ),
            Image.network(
              user.imageUrl ??
                  'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album',
              height: 180,
            ),
            Text(user.firstName ?? 'Имя'),
          ],
        ),
      ),
    );
  }
}
