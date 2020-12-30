import 'package:user_repository/user_repository.dart';
import 'package:convene/domain/authentication/email.dart';
import 'package:convene/domain/authentication/password.dart';
import 'package:formz/formz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.read, [LoginState state])
      : super(state ?? const LoginState());

  /// The `ref.read` function
  final Reader read;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    );
  }

  Future<void> loginWithCredentials() async {
    state = state.copyWith(hasSubmitted: true);

    if (!state.status.isValidated) return;

    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await read(authRepositoryProvider).logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on Exception {
      state = state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
