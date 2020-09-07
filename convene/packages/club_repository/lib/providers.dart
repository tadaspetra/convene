import 'package:riverpod/riverpod.dart';

import 'club_repository.dart';

/// Provides methods to read and write to the User database. Uses the
/// [UserDatabase] object
final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return ClubRepository(ref.read);
});
