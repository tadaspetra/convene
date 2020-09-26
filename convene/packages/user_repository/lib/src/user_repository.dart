import 'package:user_repository/src/models/database_user.dart';

abstract class UserRepository {
  // why make this abstract?
  const UserRepository();

  Future<DatabaseUser> getCurrentUser();
  Future<void> addUser(DatabaseUser user);
  Future<void> removeUser(DatabaseUser user);
  Future<void> updateUser(DatabaseUser user);
}
