part of 'map_bloc.dart';

@immutable
class MapState {
  final List<Marker> markers;
  final Position? location;

  const MapState(this.markers, this.location);
}
