import 'package:user_repository/src/models/database_user.dart';

abstract class UserRepository {
  const UserRepository();

  Future<void> addUser(DatabaseUser user);
  Future<void> removeUser(DatabaseUser user);
  Future<void> updateUser(DatabaseUser user);
}
