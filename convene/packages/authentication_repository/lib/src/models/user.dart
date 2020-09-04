import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
