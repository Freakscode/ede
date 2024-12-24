abstract class AuthState {}

class AuthUninitialized extends AuthState {}
class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String token;

  AuthAuthenticated(this.token);
}