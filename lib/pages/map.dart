import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/markers/markers.dart';
import 'package:in_pack/utils/show_dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

extension ToLatLng on Position {
  get latLng => LatLng(latitude, longitude);
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final mainSmokeRoomLatLng = LatLng(55.6699, 37.4803);
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  Future<PermissionStatus>? _locationPermission;
  Future<Position?>? _currentUserPosition;
  List<Marker> _markers = [];

  Future<Position?> get currentUserPosition =>
      _currentUserPosition ?? _requestPosition();

  Future<PermissionStatus> get locationPermission {
    if (_locationPermission != null) {
      return _locationPermission!;
    } else {
      _locationPermission = Permission.location.status;
      return _locationPermission!;
    }
  }

  void addUserMarker() async {
    types.User user = await currentFirestoreUser;
    Position? position = await currentUserPosition;
    if (position != null) {
      _markers[0] = UserMarker(position: position!, user: user);
      _mapController.move(position.latLng, 17);
    }
  }

  @override
  void initState() {
    addUserMarker();
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
          center: mainSmokeRoomLatLng,
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
        MarkerClusterLayerOptions(
          maxClusterRadius: 190,
          disableClusteringAtZoom: 16,
          size: const Size(50, 50),
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
                  : _defaultPopupBuilder(marker)),
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

  /// Get current user from firestore that used in FirebaseChatCore
  Future<types.User> get currentFirestoreUser async {
    types.User currentUser;
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDoc.data()!;
    data.addAll({'id': FirebaseAuth.instance.currentUser!.uid});
    currentUser = types.User.fromJson(data);
    return currentUser;
  }

  /// Show warning if user permanently denied access to location
  void _permanentlyDeniedWarning() {
    showInfoDialog(context,
        title: 'Ебать ты пидорас',
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Извините, но Вам придётся покончить с собой, так как '
                  'вы запретили доступ к геолокации'),
              Text('Либо зайти в настройки и там включить геолокацию',
                  style: TextStyle(fontSize: 8)),
            ]),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена')),
          CupertinoButton.filled(
              child: const Text('В настройки'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              })
        ]);
  }

  /// Return current position
  Future<Position?> _requestPosition() async {
    PermissionStatus locationStatus = await Permission.location.status;

    if (locationStatus.isGranted) {
      return Geolocator.getCurrentPosition();
    }

    if (locationStatus.isPermanentlyDenied) {
      _permanentlyDeniedWarning();
      return Geolocator.getLastKnownPosition();
    }

    if (locationStatus.isDenied) {
      PermissionStatus newStatus = await Permission.location.request();

      if (newStatus.isPermanentlyDenied) {
        _permanentlyDeniedWarning();
        return Geolocator.getLastKnownPosition();
      }

      if (newStatus.isLimited) {
        print('Status is Limited');
        return Geolocator.getCurrentPosition();
      }

      if (newStatus.isGranted) {
        return Geolocator.getCurrentPosition();
      }
    }
    return null;
  }
}
