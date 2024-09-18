// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'resturants_bloc.dart';

enum ResturantsStatus {
  initial,
  loading,
  populated,
  filtered,
  failure;

  bool get isLoading => this == loading;

  bool get isPopulated => this == populated;
  bool get isFiltered => this == filtered;
  bool get isFailure => this == failure;
}

class ResturantsState extends Equatable {
  const ResturantsState._({
    required this.status,
    required this.resturantPage,
    required this.location,
    required this.tags,
    required this.choosenTags,
    required this.filteredResturants,
  });

  ResturantsState.initial()
      : this._(
          status: ResturantsStatus.initial,
          resturantPage: ResturantPage.empty(),
          location: const Location.undefined(),
          tags: const [],
          choosenTags: const [],
          filteredResturants: const [],
        );

  final ResturantsStatus status;
  final ResturantPage resturantPage;
  final Location location;
  final List<Tag> tags;
  final List<Tag> choosenTags;
  final List<Restaurant> filteredResturants;

  @override
  List<Object> get props => [
        status,
        resturantPage,
        tags,
        location,
        choosenTags,
        filteredResturants,
      ];

  ResturantsState copyWith({
    ResturantsStatus? status,
    ResturantPage? resturantPage,
    Location? location,
    List<Tag>? tags,
    List<Tag>? choosenTags,
    List<Restaurant>? filteredResturants,
  }) {
    return ResturantsState._(
      status: status ?? this.status,
      resturantPage: resturantPage ?? this.resturantPage,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      choosenTags: choosenTags ?? this.choosenTags,
      filteredResturants: filteredResturants ?? this.filteredResturants,
    );
  }
}
