// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

final LatLng mainSmokeRoomCoords = LatLng(55.66965, 37.47935);
final LatLngBounds mainSmokeRoomBounds =
    LatLngBounds(LatLng(55.67102, 37.47649), LatLng(55.66853, 37.48386));

List<LatLng> _latLngList = [
  LatLng(55.669684, 37.478832),
  LatLng(55.669684, 37.479),
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
          plugins: <MapPlugin>[MarkerClusterPlugin()],
          center: mainSmokeRoomCoords,
          zoom: 18.5,
          maxZoom: 19,
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
          // scrollWheelVelocity: 0.005, // for newer version
          onTap: (tapPosition, LatLng latLng) {
            // TODO: create onTap
            print(
                'tapPosition: ${tapPosition.global}, ${tapPosition.relative}');
            print('latLng: $latLng');
          }),
      layers: [
        TileLayerOptions(
          minZoom: 1,
          maxZoom: 19,
          backgroundColor: Colors.black,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          // userAgentPackageName: 'com.in_pack.usmangroup', // for newer version
        ),
        // MarkerLayerOptions(
        //   markers: _markers,
        // ),
        MarkerClusterLayerOptions(
          maxClusterRadius: 190,
          disableClusteringAtZoom: 16,
          size: Size(50, 50),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: _markers,
          polygonOptions: PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              child: Text('${markers.length}'),
            );
          },
        ),
      ],
    );
  }
}
