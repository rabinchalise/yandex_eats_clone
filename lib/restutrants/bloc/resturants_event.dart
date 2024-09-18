part of 'resturants_bloc.dart';

sealed class ResturantsEvent extends Equatable {
  const ResturantsEvent();

  @override
  List<Object?> get props => [];
}

class ResturantsFetchRequested extends ResturantsEvent {
  const ResturantsFetchRequested({this.page});

  final int? page;

  @override
  List<Object?> get props => [page];
}

class ResturantsLocationChanged extends ResturantsEvent {
  const ResturantsLocationChanged({required this.location});
  final Location location;

  @override
  List<Object?> get props => [location];
}

class ResturantsRefreshRequested extends ResturantsEvent {
  const ResturantsRefreshRequested();
}

final class ResturantsFilterTagChanged extends ResturantsEvent {
  const ResturantsFilterTagChanged(this.tag);

  final Tag tag;

  @override
  List<Object?> get props => [tag];
}

class ResturantsFilterTagsChanged extends ResturantsEvent {
  const ResturantsFilterTagsChanged({this.tags});
  final List<Tag>? tags;

  @override
  List<Object?> get props => [tags];
}

class _ResturantsFilterTagAdded extends ResturantsEvent {
  const _ResturantsFilterTagAdded({required this.tag});
  final Tag tag;

  @override
  List<Object?> get props => [tag];
}

class _ResturantsFilterTagRemoved extends ResturantsEvent {
  const _ResturantsFilterTagRemoved({required this.tag});
  final Tag tag;

  @override
  List<Object?> get props => [tag];
}

class ResturantsFilterTagsCleared extends ResturantsEvent {
  const ResturantsFilterTagsCleared();
}
