import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @required String email,
    @required String id,
    String name,
  }) = _User;

  factory User.empty() => const User(
        email: '',
        id: '',
      );
}
