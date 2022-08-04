part of 'map_bloc.dart';

@immutable
abstract class MapEvent {
  const MapEvent();
}

class RequestLocation extends MapEvent{}

class MoveToUser extends MapEvent{}

class AddMarker extends MapEvent{
  final Marker marker;
  const AddMarker(this.marker);
}

class RemoveMarker extends MapEvent{
  final Marker marker;
  const RemoveMarker(this.marker);
}
