import 'package:authentication_repository/authentication_repository.dart';
import 'package:formz/formz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../authentication/models/models.dart';
import 'sign_up_state.dart';

class SignUpStateNotifier extends StateNotifier<SignUpState> {
  SignUpStateNotifier(this.read, [SignUpState state])
      : super(state ?? const SignUpState());

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

  Future<void> signUpFormSubmitted() async {
    state = state.copyWith(hasSubmitted: true);

    if (!state.status.isValidated) return;

    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await read(authRepositoryProvider).signUp(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on Exception {
      state = state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
