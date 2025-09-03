import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'users_event.dart';
import 'users_state.dart';
import 'dart:developer' as developer;

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository repository;

  UsersBloc({required this.repository}) : super(UsersInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        // This will fetch remote users and store them locally
        final users = await repository.getUsers();
        emit(UsersLoaded(users, isOnline: true));
      } catch (e) {
        developer.log('Failed to fetch users: $e');
        try {
          // Try to get local users if remote fails
          final localUsers = await repository.getLocalUsers();
          emit(UsersLoaded(localUsers, isOnline: false));
        } catch (e) {
          emit(UsersError(e.toString()));
        }
      }
    });

    on<SyncUsers>((event, emit) async {
      final currentState = state;
      if (currentState is UsersLoaded) {
        try {
          final users = await repository.fetchAndStoreAllUsers();
          emit(UsersLoaded(users));
        } catch (e) {
          emit(UsersLoaded(currentState.users, isOnline: false));
        }
      }
    });
  }
}