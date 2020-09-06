import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class DatabaseUser with _$DatabaseUser {
  const factory DatabaseUser({
    @required String uid,
    @required String email,
    String name,
  }) = _DatabaseUser;

  factory DatabaseUser.fromJson(Map<String, dynamic> json) =>
      _$DatabaseUserFromJson(json);
}
