import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sign_up_controller.dart';

final signUpController = StateNotifierProvider<SignUpController>((ref) {
  return SignUpController(ref.read);
});
