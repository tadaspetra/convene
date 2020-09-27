import 'package:convene/domain/authentication/authentication.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    FormzStatus status,
    @Default(false) bool hasSubmitted,
  }) = _LoginState;
}
