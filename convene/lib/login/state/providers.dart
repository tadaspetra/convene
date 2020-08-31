import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_state_notifier.dart';

final loginProvider = StateNotifierProvider<LoginStateNotifier>((ref) {
  return LoginStateNotifier(ref.read);
});
