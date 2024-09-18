part of 'auto_complete_bloc.dart';

abstract class AutoCompleteEvent extends Equatable {
  const AutoCompleteEvent();

  @override
  List<Object> get props => [];
}

class AutoCompleteFetchRequested extends AutoCompleteEvent {
  const AutoCompleteFetchRequested({this.searchTerm = ''});
  final String searchTerm;

  @override
  List<Object> get props => [searchTerm];
}
