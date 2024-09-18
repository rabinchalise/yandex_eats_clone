part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

class AppUpdateAccountRequested extends AppEvent {
  const AppUpdateAccountRequested({required this.username});
  final String? username;

  @override
  List<Object?> get props => [username];
}

class AppUpdateAccountEmailRequested extends AppEvent {
  const AppUpdateAccountEmailRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AppDeleteAccountRequested extends AppEvent {}

final class AppUserLocationChanged extends AppEvent {
  const AppUserLocationChanged({required this.location});

  final Location location;

  @override
  List<Object> get props => [location];
}

class AppLogoutRequested extends AppEvent {}
