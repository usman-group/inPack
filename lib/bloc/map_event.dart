part of 'map_bloc.dart';

@immutable
abstract class MapEvent {
  const MapEvent();
}

class RequestLocation extends MapEvent {
  final MapController mapController;
  const RequestLocation(this.mapController);
}

class MoveToUser extends MapEvent {}

class MoveToCurrentPosition extends MapEvent {
  final MapController mapController;
  const MoveToCurrentPosition(this.mapController);
}

class AddMarker extends MapEvent {
  final Marker marker;
  const AddMarker(this.marker);
}

class RemoveMarker extends MapEvent {
  final Marker marker;
  const RemoveMarker(this.marker);
}
