part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationChanged extends LocationEvent {
  const LocationChanged({required this.location});
  final Location location;

  @override
  List<Object?> get props => [location];
}

class LocationFetchAddressRequested extends LocationEvent {
  const LocationFetchAddressRequested();
}
