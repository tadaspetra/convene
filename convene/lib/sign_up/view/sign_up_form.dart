import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../sign_up.dart';

final _signUpFormStatus = Provider<FormzStatus>((ref) {
  final signUp = ref.watch(signUpProvider.state);
  return signUp.status;
});

class SignUpForm extends StatelessWidget {
  const SignUpForm();

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: _signUpFormStatus,
      onChange: (FormzStatus status) {
        if (status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Registration Failure'),
              ), //TODO provide better messages
            );
        }
      },
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _EmailInput(),
            _PasswordInput(),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

/// Determines if the email from [_EmailInput] is an invalid email and
/// if a sign up has been submitted.
///
/// This is an optimization method. [_EmailInput] will only rebuild when
/// [_showEmailErrorMessage] changes value.
final _showEmailErrorMessage = Provider<bool>((ref) {
  final signUp = ref.watch(signUpProvider.state);
  return signUp.email.invalid && signUp.hasSubmitted;
});

class _EmailInput extends HookWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read(signUpProvider).emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: useProvider(_showEmailErrorMessage) ? 'invalid email' : null,
      ),
    );
  }
}

/// Determines if the password from [_PasswordInput] is an invalid password and
/// if a sign up has been submitted.
///
/// This is an optimization method. [_PasswordInput] will only rebuild when
/// [_showPasswordErrorMessage] changes value.
final _showPasswordErrorMessage = Provider<bool>((ref) {
  final signUp = ref.watch(signUpProvider.state);
  return signUp.password.invalid && signUp.hasSubmitted;
});

class _PasswordInput extends HookWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read(signUpProvider).passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText:
            useProvider(_showPasswordErrorMessage) ? 'invalid password' : null,
      ),
    );
  }
}

class _SignUpButton extends HookWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final form = useProvider(_signUpFormStatus);
    return SizedBox(
      // specify a height, to ensure the same height for both children
      height: 75,
      child: Center(
        child: form.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                onPressed: () {
                  context.read(signUpProvider).signUpFormSubmitted();
                },
                child: const Text('SIGN UP'),
              ),
      ),
    );
  }
}
