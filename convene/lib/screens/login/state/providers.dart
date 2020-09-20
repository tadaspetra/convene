import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_controller.dart';

final loginController = StateNotifierProvider<LoginController>((ref) {
  return LoginController(ref.read);
});
