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

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  static final mainSmokeRoomLatLng = LatLng(55.6699, 37.4803);
  LatLng? currentUserLatLng;
  Position? currentUserPosition;
  UserMarker? currentUserMarker;

  Future<void> _initLocation() async {
    currentUserPosition = await _getCurrentUserPosition();
    currentUserLatLng = _positionToLatLng(currentUserPosition);
    currentUserMarker = await _getCurrentUserMarker();
  }

  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initLocation();
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          plugins: <MapPlugin>[
            MarkerClusterPlugin(),
          ],
          center: currentUserLatLng ?? mainSmokeRoomLatLng,

          /// Initial center if not specified bounds
          zoom: 18.5,

          /// Initial zoom if not specified bounds
          maxZoom: 19,
          minZoom: 1,

          /// [bounds] is Initial map bounds
          // bounds: currentPositionLatLng,

          maxBounds: LatLngBounds(
            // Max map bounds
            LatLng(-90, -180.0),
            LatLng(90.0, 180.0),
          ),
          rotation: 0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          enableScrollWheel: true,
          onTap: (tapPosition, LatLng latLng) =>
              _popupController.hideAllPopups()),
      layers: [
        // Main layer of map
        TileLayerOptions(
          minZoom: 1,
          maxZoom: 19,
          backgroundColor: Colors.black,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        // Layer of cluster markers with popups
        MarkerClusterLayerOptions(
          maxClusterRadius: 190,
          disableClusteringAtZoom: 16,
          size: const Size(50, 50),
          fitBoundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: currentUserMarker != null
              ? <Marker>[currentUserMarker!]
              : const [],
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

  LatLng? _positionToLatLng(Position? position) {
    if (position == null) {
      return null;
    } else {
      return LatLng(position.latitude, position.longitude);
    }
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<UserMarker?> _getCurrentUserMarker() async {
    types.User currentUser = await _getCurrentUserInFirestore();
    var curPos = await _getCurrentUserPosition();
    return curPos == null
        ? null
        : UserMarker(position: curPos, user: currentUser);
  }

  Future<types.User> _getCurrentUserInFirestore() async {
    types.User currentUser;
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = userDoc.data()!;
    data.addAll({'id': FirebaseAuth.instance.currentUser!.uid});
    print(data);
    currentUser = types.User.fromJson(data);
    return currentUser;
  }

  void _sweetWarningAboutPermanentlyDenied() {
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

  // TODO: make cloud markers for user and smoke rooms
  Future<Position?> _getCurrentUserPosition() async {
    var locationStatus = await Permission.location.status;
    if (locationStatus.isPermanentlyDenied) {
      _sweetWarningAboutPermanentlyDenied();
    } else if (locationStatus.isDenied) {
      Permission.location.request().then((value) {
        if (value.isPermanentlyDenied) {
          _sweetWarningAboutPermanentlyDenied();
        } else if (value.isLimited) {
          showInfoDialog(context,
              title: 'Ну почти нормально',
              content: const Text(
                  'Показывает value is Limited, пока не понятно че это'));
        }
      });
    } else if (locationStatus.isGranted) {
      return await Geolocator.getCurrentPosition().then((value) {
        if (!mounted) return;
        print('Пользователь был найден ебать');
        setState(() {});
      });
    }
  }
}
