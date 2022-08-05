import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/bloc/map_bloc.dart';
import 'package:in_pack/markers/markers.dart';
import 'package:in_pack/markers/user_marker.dart';
import 'package:in_pack/utils/navbar_page.dart';
import 'package:latlong2/latlong.dart';



class MapPage extends StatefulWidget implements NavigationBarPage {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();

  @override
  Icon get icon => const Icon(Icons.maps_home_work_rounded);

  @override
  String get label => 'Карта';
}

class _MapPageState extends State<MapPage> {
  static final mireaLatLng = LatLng(55.6699, 37.4803);
  final PopupController _popupController = PopupController();
  late final MapBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<MapBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return FlutterMap(
          mapController: state.mapController,
          options: MapOptions(
              plugins: <MapPlugin>[
                MarkerClusterPlugin(),
              ],
              center: mireaLatLng,
              zoom: 18.5,
              maxZoom: 19,
              minZoom: 1,
              maxBounds: LatLngBounds(
                LatLng(-90, -180.0),
                LatLng(90.0, 180.0),
              ),
              rotation: 0,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              enableScrollWheel: true,
              onTap: (tapPosition, LatLng latLng) =>
                  _popupController.hideAllPopups()),
          layers: [
            TileLayerOptions(
              minZoom: 1,
              maxZoom: 19,
              backgroundColor: Colors.black,
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),

            // All work with markers
            MarkerClusterLayerOptions(
              maxClusterRadius: 190,
              disableClusteringAtZoom: 16,
              size: const Size(50, 50),
              fitBoundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: state.markers,
              polygonOptions: const PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 3),
              popupOptions: PopupOptions(
                  popupSnap: PopupSnap.mapBottom,
                  popupController: _popupController,
                  
                  /// Widget of marker popup
                  popupBuilder: (context, marker) => marker is MarkerWithPopup
                      ? marker.popupBuilder(context)
                      : _defaultPopupBuilder(marker)),

              /// Widget of markers cluster
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
      },
    );
  }

  /// If Marker has no popup builder just show this popup
  Widget _defaultPopupBuilder(marker) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 50,
      decoration:
          const BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
      child: Text(
        marker.point.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  
}
