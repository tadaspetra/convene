import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import '../authentication_repository.dart';

/// Provides methods to interact with Firebase Authentication.
final authRepositoryProvider = Provider((ref) => AuthenticationRepository());

/// Stream of [User]. Will be updated when the logged in user changes.
final userProvider = StreamProvider<User>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.user;
});

/// Returns the current logged-in user's [User.uid]
final userUidProvider = FutureProvider<String>((ref) async {
  final user = await ref.watch(userProvider.last);
  return user.uid;
});

/// Returns the current authentication state - [AuthenticationState]
final authStateProvider = Provider<AuthenticationState>((ref) {
  final user = ref.watch(userProvider);
  return user.when(
    data: (user) {
      if (user == null) {
        return const AuthenticationState.unauthenticated();
      }
      return AuthenticationState.authenticated(user);
    },
    loading: () {
      return const AuthenticationState.unknown();
    },
    error: (err, stack) {
      debugPrint(err.toString());
      return AuthenticationState.error(err);
    },
  );
});
