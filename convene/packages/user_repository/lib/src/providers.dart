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
final userRespositoryProvider = Provider<UserRepository>((ref) {
  return FirestoreUserRepository(ref.read);
});

final databaseUserProvider = FutureProvider<DatabaseUser>((ref) {
  final databaseRepo = ref.watch(userRespositoryProvider);
  return databaseRepo.getCurrentUser();
});

/// Stream of [User]. Will be updated when the logged in user changes.
final authUserProvider = StreamProvider<User>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.user;
});

/// Returns the current authentication state - [AuthenticationState]
final authStateProvider = Provider<AuthenticationState>((ref) {
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

// list of books being currently read by the user
final currentUserController = StateNotifierProvider<CurrentUser>((ref) {
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
