import 'package:freezed_annotation/freezed_annotation.dart';

part 'database_user.freezed.dart';
part 'database_user.g.dart';

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
