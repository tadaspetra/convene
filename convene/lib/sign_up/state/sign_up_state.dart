import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../authentication/models/models.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    FormzStatus status,
    @Default(false) bool hasSubmitted,
  }) = _SignUpState;
}
