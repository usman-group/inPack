import 'package:flutter/material.dart';

import 'markers.dart';

class SmokeRoomMarker extends MarkerWithPopup {
  SmokeRoomMarker({
    required super.point,
    required this.name,
    this.imageUrl,
    this.description,
  }) : super(builder: markerBuilder);
  final String name;
  final String? imageUrl;
  final String? description;
  static const defaultSmokeRoomImageUrl =
      'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album';

  static Icon markerBuilder(BuildContext context) {
    return const Icon(
      Icons.smoking_rooms_rounded,
      color: Colors.brown,
      size: markerSize,
    );
  }

  @override
  Widget popupBuilder(BuildContext context) {
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
              imageUrl ?? defaultSmokeRoomImageUrl,
              height: 180,
            ),
            description == null
                ? const Text(
              'Нет описания',
              style: emptyFieldTextStyle,
            )
                : Text(
              description!,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get categoryName => 'Курилка';
}