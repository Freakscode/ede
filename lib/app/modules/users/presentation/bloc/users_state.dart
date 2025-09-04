import '../../data/models/user_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}
class UsersLoading extends UsersState {}
class UsersLoaded extends UsersState {
  final List<UserModel> users;
  final bool isOnline;
  
  UsersLoaded(this.users, {this.isOnline = true});
}
class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}