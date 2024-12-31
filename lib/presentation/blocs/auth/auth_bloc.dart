import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc <AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthUninitialized()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final hasToken = await authRepository.hasToken();
      if (hasToken){
        final token = await authRepository.getToken();
        emit(AuthAuthenticated(token!));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.username, event.password);
        final token = await authRepository.getToken();
        emit(AuthAuthenticated(token!));
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });

  }
}