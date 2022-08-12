part of 'map_bloc.dart';

@immutable
class MapState {
  final List<Marker> markers;
  final Position? position;

  const MapState(this.markers, this.position);
}
