import 'package:authentication_repository/authentication_repository.dart';

abstract class UserRepository {
  const UserRepository();

  Future<void> addUser(User user);
  Future<void> removeUser(User user);
  Future<void> updateUser(User user);
}
