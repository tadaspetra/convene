import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/services/firebase_auth.dart';
import 'package:user_repository/src/services/firestore_user.dart';
import 'package:user_repository/src/user_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:state_notifier/state_notifier.dart';

/// Provides methods to interact with Firebase Authentication.
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => FirebaseAuthRepository());
//TODO: You can't instantiate a abstract class, is there a better way to do this?

/// Provides methods to read and write to the User database.
final userRespositoryProvider = Provider.autoDispose<UserRepository>((ref) {
  return FirestoreUserRepository(ref.read);
});

/// Stream of [User]. Will be updated when the logged in user changes.
final authUserProvider = StreamProvider.autoDispose<User>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.user;
});

/// Returns the current authentication state - [AuthenticationState]
final authStateProvider = Provider.autoDispose<AuthenticationState>((ref) {
  final user = ref.watch(authUserProvider);
  return user.when(
    data: (user) {
      if (user == null) {
        return const AuthenticationState.unauthenticated();
      } else {
        if (user.emailVerified == true) {
          return AuthenticationState.authenticated(user);
        } else {
          return const AuthenticationState.emailNotVerified();
        }
      }
    },
    loading: () {
      return const AuthenticationState.loading();
    },
    error: (err, stack) {
      debugPrint(err.toString());
      return AuthenticationState.error(err);
    },
  );
});
final databaseUserProvider = FutureProvider.autoDispose<DatabaseUser>((ref) {
  final databaseRepo = ref.watch(userRespositoryProvider);
  return databaseRepo.getCurrentUser();
});

final currentUserController =
    StateNotifierProvider.autoDispose<CurrentUser>((ref) {
  return CurrentUser(ref.read);
});

class CurrentUser extends StateNotifier<AsyncValue<DatabaseUser>> {
  CurrentUser(this.read) : super(const AsyncLoading()) {
    _getUser();
  }

  final Reader read;

  Future<void> _getUser() async {
    try {
      final DatabaseUser user =
          await read(userRespositoryProvider).getCurrentUser();

      state = AsyncData(user);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }
}
