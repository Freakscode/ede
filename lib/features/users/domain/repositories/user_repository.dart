import '../../../users/data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(String id);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<bool> deleteUser(String id);
  
  // Legacy methods for compatibility
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getLocalUsers();
  Future<List<UserModel>> fetchAndStoreAllUsers();
}
