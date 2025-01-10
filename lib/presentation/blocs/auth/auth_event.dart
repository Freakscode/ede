abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({
    required this.username,
    required this.password,
  });
}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}