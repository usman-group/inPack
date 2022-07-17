// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final LatLng mainSmokeRoomCoords = LatLng(55.66965, 37.47935);
final LatLngBounds mainSmokeRoomBounds =
    LatLngBounds(LatLng(55.67102, 37.47649), LatLng(55.66853, 37.48386));

List<LatLng> _latLngList = [
  LatLng(55.669684, 37.478832),
];

List<Marker> _markers = _latLngList
    .map((point) => Marker(
          point: point,
          width: 60,
          height: 60,
          builder: (context) => Icon(
            Icons.smoking_rooms_rounded,
            size: 60,
            color: Colors.blueAccent,
          ),
        ))
    .toList();

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: mainSmokeRoomCoords,
          zoom: 18.0,
          maxZoom: 18,
          minZoom: 1,
          // Paris
          bounds: mainSmokeRoomBounds,
          maxBounds: LatLngBounds(
            LatLng(-90, -180.0),
            LatLng(90.0, 180.0),
          ),
          // Initial rotation
          rotation: 0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          enableScrollWheel: true,
          scrollWheelVelocity: 0.005,
          onTap: (tapPosition, LatLng latLng) {
            // TODO: create onTap
            print(
                'tapPosition: ${tapPosition.global}, ${tapPosition.relative}');
            print('latLng: $latLng');
          }),
      layers: [
        TileLayerOptions(
          minZoom: 1,
          maxZoom: 18,
          backgroundColor: Colors.black,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.in_pack.usmangroup',
        ),
        MarkerLayerOptions(
          markers: _markers,
        )
      ],
    );
  }
}
