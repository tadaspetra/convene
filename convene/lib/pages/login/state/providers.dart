import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_controller.dart';

final loginController = StateNotifierProvider<LoginController>((ref) {
  return LoginController(ref.read);
});
