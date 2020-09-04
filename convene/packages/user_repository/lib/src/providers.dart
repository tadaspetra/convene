import 'package:authentication_repository/authentication_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:user_repository/user_repository.dart';

import 'firebase_user_repository.dart';

/// User Repository. Provides methods to read and write to the User database
///
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirebaseUserRepository(ref.read);
});
