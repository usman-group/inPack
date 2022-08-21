part of 'map_bloc.dart';

@immutable
abstract class MapEvent {
  final BuildContext context;
  final MapController mapController;
  const MapEvent({required this.mapController, required this.context});
}

class RequestLocation extends MapEvent {
  const RequestLocation({required super.mapController, required super.context});

}

class MoveToUser extends MapEvent {
  const MoveToUser({required super.mapController, required super.context});
}

class MoveToCurrentPosition extends MapEvent {
  const MoveToCurrentPosition({required super.mapController, required super.context});

}

class AddMarker extends MapEvent {
  final EquatableMarker marker;

  const AddMarker({required super.mapController, required super.context, required this.marker});

}

class RemoveMarker extends MapEvent {
  final EquatableMarker marker;

  const RemoveMarker({ required this.marker, required super.mapController, required super.context});

}
