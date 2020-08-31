import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'authentication_state.dart';

final authStateProvider = Provider<AuthenticationState>((ref) {
  final user = ref.watch(userProvider);
  return user.when(
    data: (user) {
      if (user == User.empty()) {
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
