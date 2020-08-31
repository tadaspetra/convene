import 'package:riverpod/riverpod.dart';

import '../authentication_repository.dart';

/// Authentication Repository. Provides methods to interact with Firebase
/// authentication.
///
final authRepositoryProvider = Provider((ref) => AuthenticationRepository());

/// Stream of [User]. Will be updated when the logged in user changes.
///
final userProvider = StreamProvider<User>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.user;
});
