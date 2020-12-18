import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sign_up_controller.dart';

final signUpController = StateNotifierProvider<SignUpController>((ref) {
  return SignUpController(ref.read);
});
