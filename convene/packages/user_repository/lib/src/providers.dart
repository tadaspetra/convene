import 'package:riverpod/riverpod.dart';
import 'package:user_repository/user_repository.dart';

import 'database_user_repository.dart';

/// Provides methods to read and write to the User database. Uses the
/// [UserDatabase] object
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return DatabaseUserRepository(ref.read);
});
