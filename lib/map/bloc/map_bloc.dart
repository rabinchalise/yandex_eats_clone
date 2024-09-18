import 'dart:async';

import 'package:api/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_repository/location_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required LocationRepository locationRepository,
    required UserRepository userRepository,
  })  : _locationRepository = locationRepository,
        _userRepository = userRepository,
        super(MapState.initial()) {
    on<MapCreateRequested>(_onCreateRequested);
    on<MapCameraMoveStartRequested>(_onCameraMoveStartRequested);
    on<MapCameraMoveRequested>(_onCameraMoveRequested);
    on<MapCameraIdleRequested>(_onMapCameraIdleRequested);
    on<MapAnimateToPlaceDetails>(_onAnimateToPlaceDetails);
    on<MapAnimateToPositionRequested>(_onAnimateToPositionRequested);
    on<MapAnimateToCurrentPositionRequested>(
      _onAnimateToCurrentPositionRequested,
    );
    on<MapPositionSaveRequested>(_onPostionSaveRequest);
  }

  final LocationRepository _locationRepository;
  final UserRepository _userRepository;

  Future<void> _onCreateRequested(
    MapCreateRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final controller = event.controller;
      emit(
        state.copyWith(
          mapController: state.mapController..complete(controller),
        ),
      );
      final currentPostion = _userRepository.fetchCurrentLocation();
      if (currentPostion.isUndefined) return;

      if (isClosed) return;
      add(
        MapAnimateToPositionRequested(
          position: LatLng(currentPostion.lat, currentPostion.lng),
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _onCameraMoveStartRequested(
    MapCameraMoveStartRequested event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(isCameraMoving: true));
  }

  void _onCameraMoveRequested(
    MapCameraMoveRequested event,
    Emitter<MapState> emit,
  ) {
    if (isClosed) return;
    emit(
      state.copyWith(
        isCameraMoving: true,
        currentPosition: event.position.target,
      ),
    );
  }

  Future<void> _onMapCameraIdleRequested(
    MapCameraIdleRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isCameraMoving: false,
          status: MapStatus.fetchingAddressLoading,
        ),
      );
      //fetch address from current position,
      final addressName = await _fetchFormattedAddress(state.currentPosition);
      emit(
        state.copyWith(
          addressName: addressName,
          status: MapStatus.fetchingAddressSuccess,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: MapStatus.fetchingAddressFailure));
    }
  }

  Future<String> _fetchFormattedAddress(LatLng location) async {
    return _locationRepository.getFormattedAddress(
      location.latitude,
      location.longitude,
    );
  }

  Future<void> _onAnimateToPositionRequested(
    MapAnimateToPositionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final mapController = state.mapController;
      await mapController.future.then(
        (gMap) => gMap.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: event.position,
              zoom: event.zoom,
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onAnimateToPlaceDetails(
    MapAnimateToPlaceDetails event,
    Emitter<MapState> emit,
  ) {
    final lat = event.placeDetails?.location.lat;
    final lng = event.placeDetails?.location.lng;

    if (lat == null && lng == null) return;

    final newPosition = LatLng(lat!, lng!);
    add(MapAnimateToPositionRequested(position: newPosition));
  }

  Future<void> _onAnimateToCurrentPositionRequested(
    MapAnimateToCurrentPositionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final currentPosition = await _locationRepository.getCurrentPosition();
      final position =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      if (isClosed) return;
      add(MapAnimateToPositionRequested(position: position));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onPostionSaveRequest(
    MapPositionSaveRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final position = state.currentPosition;
      final newLocation =
          Location(lat: position.latitude, lng: position.longitude);

      if (newLocation == currentLocation) return;

      await _userRepository.changeLocation(location: newLocation);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }
}
