import 'package:in_pack/markers/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final MapController _mapController = MapController();
  static final PopupController _popupController = PopupController();
  final LatLng mainSmokeRoomCoords = LatLng(55.66965, 37.47935);
  late final List<Marker> _markers;
  final LatLngBounds mainSmokeRoomBounds =
      LatLngBounds(LatLng(55.67102, 37.47649), LatLng(55.66853, 37.48386));

  final List<LatLng> _latLngList = [
    LatLng(55.669649, 37.478643),
    LatLng(55.670194, 37.477297),
  ];
  @override
  void initState() {
    _markers = _latLngList
        .map((point) => SmokeRoomMarker(
            point: point,
            name: 'МИРЭА',
            description: 'хайповая курилочка у входа в МИРЭА'))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          plugins: <MapPlugin>[
            MarkerClusterPlugin(),
          ],
          center: mainSmokeRoomCoords,

          /// Initial center if not specified bounds
          zoom: 18.5,

          /// Initial zoom if not specified bounds
          maxZoom: 19,
          minZoom: 1,
          bounds: mainSmokeRoomBounds, // Initial map bounds
          maxBounds: LatLngBounds(
            // Max map bounds
            LatLng(-90, -180.0),
            LatLng(90.0, 180.0),
          ),
          rotation: 0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          enableScrollWheel: true,
          // scrollWheelVelocity: 0.005, // for newer version
          onTap: (tapPosition, LatLng latLng) {
            // TODO: create onTap
            _popupController.hideAllPopups();
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
        MarkerClusterLayerOptions(
          maxClusterRadius: 190,
          disableClusteringAtZoom: 16,
          size: Size(50, 50),
          fitBoundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: _markers,
          polygonOptions: const PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          popupOptions: PopupOptions(
              popupSnap: PopupSnap.mapBottom,
              popupController: _popupController,
              popupBuilder: (context, marker) => marker is MarkerWithPopup
                  ? marker.popupBuilder()
                  : _defaultMarkerPopup(marker)),
          builder: (context, markers) {
            return Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.orange, shape: BoxShape.circle),
              child: Text('${markers.length}'),
            );
          },
        ),
      ],
    );
  }

  Widget _defaultMarkerPopup(marker) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 50,
      decoration:
          const BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
      child: Text(
        marker.point.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
