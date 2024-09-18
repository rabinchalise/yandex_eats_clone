part of 'app_bloc.dart';

enum AppStatus {
  unauthenticated,
  authenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    required this.user,
    this.location = const Location.undefined(),
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);
  const AppState.unauthenticated()
      : this._(
          status: AppStatus.unauthenticated,
          user: User.anonymous,
        );

  final AppStatus status;
  final User user;
  final Location location;

  @override
  List<Object?> get props => [
        status,
        user,
        location,
      ];

  AppState copyWith({
    AppStatus? status,
    User? user,
    Location? location,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      location: location ?? this.location,
    );
  }
}
