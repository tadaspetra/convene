import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sign_up_state_notifier.dart';

final signUpProvider = StateNotifierProvider<SignUpStateNotifier>((ref) {
  return SignUpStateNotifier(ref.read);
});
