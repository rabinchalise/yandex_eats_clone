import 'dart:async';

import 'package:api/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'resturants_event.dart';
part 'resturants_state.dart';
part 'resturants_bloc_mixin.dart';

class ResturantsBloc extends Bloc<ResturantsEvent, ResturantsState>
    with ResturantsBlocMixin {
  ResturantsBloc({
    required RestaurantsRepository resturantsRepository,
    required UserRepository userRepository,
  })  : _resturantsRepository = resturantsRepository,
        _userRepository = userRepository,
        super(ResturantsState.initial()) {
    on<ResturantsFetchRequested>(_onFetchRequested);
    on<ResturantsLocationChanged>(_onResturantsLocationChanged);
    on<ResturantsRefreshRequested>(_onRefreshRequested);
    on<ResturantsFilterTagChanged>(_onFilterTagChanged);
    on<_ResturantsFilterTagAdded>(_onFilterTagAdded);
    on<_ResturantsFilterTagRemoved>(_onFilterTagRemoved);
    on<ResturantsFilterTagsCleared>(_onFilterTagsCleared);
    on<ResturantsFilterTagsChanged>(_onRestaurantsFilterTagsChanged);
    _locationSubscription = _userRepository
        .currentLocation()
        .listen(_onLocationChanged, onError: addError);
  }
  final RestaurantsRepository _resturantsRepository;
  final UserRepository _userRepository;

  StreamSubscription<Location>? _locationSubscription;

  @override
  RestaurantsRepository get resturantsRepository => _resturantsRepository;

  void _onLocationChanged(Location location) =>
      add(ResturantsLocationChanged(location: location));

  void _onResturantsLocationChanged(
    ResturantsLocationChanged event,
    Emitter<ResturantsState> emit,
  ) {
    final location = event.location;
    if (state.location == location) return;
    if (location.isUndefined) return;

    emit(
      state.copyWith(
        location: location,
        filteredResturants: [],
        choosenTags: [],
      ),
    );
    add(const ResturantsFetchRequested());
  }

  Future<void> _onFetchRequested(
    ResturantsFetchRequested event,
    Emitter<ResturantsState> emit,
  ) async {
    try {
      final currentPage = event.page ?? state.resturantPage.page;

      emit(
        state.copyWith(
          status: currentPage == 0 ? ResturantsStatus.loading : null,
        ),
      );
      final (:newPage, :hasMore, :resturants) = await fetchResturantsPage(
        page: currentPage,
      );
      final tags = currentPage == 0
          ? await _resturantsRepository.getTags(location: state.location)
          : null;
      final filteredResturants = _filterRestaurants(resturants);

      emit(
        state.copyWith(
          status: ResturantsStatus.populated,
          tags: tags,
          resturantPage: state.resturantPage.copyWith(
            page: newPage,
            hasMore: hasMore,
            resturants: [
              ...state.resturantPage.resturants,
              ...filteredResturants,
            ],
            totalResturants:
                state.resturantPage.totalResturants + resturants.length,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResturantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onRefreshRequested(
    ResturantsRefreshRequested event,
    Emitter<ResturantsState> emit,
  ) async {
    emit(state.copyWith(status: ResturantsStatus.loading));
    try {
      final (:newPage, :hasMore, :resturants) = await fetchResturantsPage();
      final tags =
          await _resturantsRepository.getTags(location: state.location);

      final filteredRestaurants = _filterRestaurants(resturants);

      emit(
        state.copyWith(
          status: ResturantsStatus.populated,
          tags: tags,
          resturantPage: ResturantPage(
            page: newPage,
            resturants: filteredRestaurants,
            hasMore: hasMore,
            totalResturants: filteredRestaurants.length,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResturantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onFilterTagChanged(
    ResturantsFilterTagChanged event,
    Emitter<ResturantsState> emit,
  ) {
    final tag = event.tag;
    !state.choosenTags.contains(tag)
        ? add(_ResturantsFilterTagAdded(tag: tag))
        : add(_ResturantsFilterTagRemoved(tag: tag));
  }

  Future<void> _onRestaurantsFilterTagsChanged(
    ResturantsFilterTagsChanged event,
    Emitter<ResturantsState> emit,
  ) async {
    final tags = event.tags ?? state.choosenTags;
    emit(
      state.copyWith(
        status: ResturantsStatus.loading,
        choosenTags: tags,
      ),
    );

    if (tags.isEmpty) {
      return add(const ResturantsFilterTagsCleared());
    }

    try {
      final restaurants = await _resturantsRepository.getRestaurantsByTags(
        tags: tags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _filterRestaurants(restaurants);

      emit(
        state.copyWith(
          filteredResturants: filteredRestaurants,
          status: ResturantsStatus.filtered,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResturantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onFilterTagAdded(
    _ResturantsFilterTagAdded event,
    Emitter<ResturantsState> emit,
  ) {
    final tag = event.tag;
    emit(
      state.copyWith(
        status: ResturantsStatus.loading,
        choosenTags: [...state.choosenTags, tag],
      ),
    );
    add(const ResturantsFilterTagsChanged());
  }

  void _onFilterTagRemoved(
    _ResturantsFilterTagRemoved event,
    Emitter<ResturantsState> emit,
  ) {
    final tag = event.tag;
    emit(
      state.copyWith(
        choosenTags: [...state.choosenTags]..remove(tag),
      ),
    );
    add(const ResturantsFilterTagsChanged());
  }

  Future<void> _onFilterTagsCleared(
    ResturantsFilterTagsCleared event,
    Emitter<ResturantsState> emit,
  ) async {
    emit(state.copyWith(status: ResturantsStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1)).whenComplete(
      () => emit(
        state.copyWith(
          filteredResturants: [],
          choosenTags: [],
          status: ResturantsStatus.populated,
        ),
      ),
    );
  }

  List<Restaurant> _filterRestaurants(List<Restaurant> restaurants) {
    return restaurants
      ..whereMoveToTheFront((restaurant) {
        if (restaurant.rating == null) return false;
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating == null) return false;
        final rating = restaurant.rating as double;
        return rating < 4.5 || restaurant.userRatingsTotal <= 100;
      });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
