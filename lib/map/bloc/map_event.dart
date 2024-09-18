part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapCreateRequested extends MapEvent {
  const MapCreateRequested({required this.controller});

  final GoogleMapController controller;

  @override
  List<Object?> get props => [controller];
}

class MapCameraMoveStartRequested extends MapEvent {
  const MapCameraMoveStartRequested();
}

class MapCameraMoveRequested extends MapEvent {
  const MapCameraMoveRequested({required this.position});
  final CameraPosition position;

  @override
  List<Object?> get props => [position];
}

class MapCameraIdleRequested extends MapEvent {
  const MapCameraIdleRequested();
}

class MapAnimateToPlaceDetails extends MapEvent {
  const MapAnimateToPlaceDetails({this.placeDetails});
  final PlaceDetails? placeDetails;
  @override
  List<Object?> get props => [placeDetails];
}

class MapAnimateToPositionRequested extends MapEvent {
  const MapAnimateToPositionRequested({
    required this.position,
    this.zoom = 18,
  });
  final LatLng position;
  final double zoom;
  @override
  List<Object?> get props => [position, zoom];
}

class MapAnimateToCurrentPositionRequested extends MapEvent {}

class MapPositionSaveRequested extends MapEvent {
  const MapPositionSaveRequested();
}
