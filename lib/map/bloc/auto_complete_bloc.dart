import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_repository/location_repository.dart';

part 'auto_complete_event.dart';
part 'auto_complete_state.dart';

class AutoCompleteBloc extends Bloc<AutoCompleteEvent, AutoCompleteState> {
  AutoCompleteBloc({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(const AutoCompleteState.initial()) {
    on<AutoCompleteFetchRequested>(_onAutoCompleteFetchRequested);
  }

  final LocationRepository _locationRepository;

  Future<void> _onAutoCompleteFetchRequested(
    AutoCompleteFetchRequested event,
    Emitter<AutoCompleteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AutoCompleteStatus.loading));
      final autoComplete =
          await _locationRepository.getAutoCompletes(input: event.searchTerm);
      emit(
        state.copyWith(
          status: AutoCompleteStatus.populated,
          autoCompletes: autoComplete,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AutoCompleteStatus.failure));
      addError(error, stackTrace);
    }
  }
}
