part of 'map_bloc.dart';

@immutable
class MapState {
  final List<Marker> markers;
  final Position? location;
  final MapController mapController;

  const MapState(this.markers, this.location, this.mapController);
}
