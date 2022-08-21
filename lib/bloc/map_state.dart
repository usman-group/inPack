part of 'map_bloc.dart';

@immutable
class MapState {
  final Set<EquatableMarker> markers;
  final Position? position;

  const MapState(this.markers, this.position);
}
