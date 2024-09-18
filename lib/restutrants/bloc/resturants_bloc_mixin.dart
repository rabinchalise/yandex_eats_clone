part of 'resturants_bloc.dart';

typedef PaginatedResturantsResult
    = Future<({int newPage, bool hasMore, List<Restaurant> resturants})>;
mixin ResturantsBlocMixin on Bloc<ResturantsEvent, ResturantsState> {
  int get pageLimit => 4;

  RestaurantsRepository get resturantsRepository;

  PaginatedResturantsResult fetchResturantsPage({int page = 0}) async {
    final currentPage = page;

    final resturants = await resturantsRepository.getRestaurants(
      location: state.location,
      offset: pageLimit * currentPage,
      limit: pageLimit,
    );

    final newPage = currentPage + 1;
    final hasMore = resturants.length >= pageLimit;

    return (newPage: newPage, hasMore: hasMore, resturants: resturants);
  }
}
