import 'dart:async';

import 'package:api/client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resturants_repository/resturants_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required RestaurantsRepository resturantsRepository,
    required UserRepository userRepository,
  })  : _resturantsRepository = resturantsRepository,
        _userRepository = userRepository,
        super(const SearchState.initial()) {
    on<SearchTermChanged>(
      (event, emit) async {
        if (event.searchTerm.isEmpty) {
          return _onEmptySearchRequested(event, emit);
        }
        return _onSearchTermChanged(event, emit);
      },
    );
  }

  final UserRepository _userRepository;
  final RestaurantsRepository _resturantsRepository;

  FutureOr<void> _onEmptySearchRequested(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.popular,
      ),
    );
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final popularRestaurants =
          await _resturantsRepository.popularSearch(location: currentLocation);
      emit(
        state.copyWith(
          restaurants: popularRestaurants,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.relevant,
      ),
    );
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final relevantRestaurants = await _resturantsRepository.relevantSearch(
        term: event.searchTerm,
        location: currentLocation,
      );
      emit(
        state.copyWith(
          restaurants: relevantRestaurants,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }
}
