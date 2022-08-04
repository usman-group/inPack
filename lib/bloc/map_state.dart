part of 'map_bloc.dart';

@immutable
class MapState {
  final List<Marker> markers;
  final Position? userPosition;

  const MapState(this.markers, this.userPosition);
}
