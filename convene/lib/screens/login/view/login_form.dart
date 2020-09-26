import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../sign_up/view/sign_up_page.dart';
import '../state/state.dart';

final _loginFormStatus = Provider<FormzStatus>((ref) {
  final login = ref.watch(loginController.state);
  return login.status;
});

class LoginForm extends StatelessWidget {
  const LoginForm();

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: _loginFormStatus,
      onChange: (FormzStatus status) {
        if (status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Authentication Failure'),
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
            _LoginButton(),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

/// Determines if the email from [_EmailInput] is an invalid email and if
/// login has been submitted
///
/// This is an optimization method. [_EmailInput] will only rebuild when
/// [_showEmailErrorMessage] changes value.
final _showEmailErrorMessage = Provider<bool>((ref) {
  final login = ref.watch(loginController.state);
  return login.email.invalid && login.hasSubmitted;
});

class _EmailInput extends HookWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read(loginController).emailChanged(email),
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
/// if login has been submitted.
///
/// This is an optimization method. [_PasswordInput] will only rebuild when
/// [_showPasswordErrorMessage] changes value.
final _showPasswordErrorMessage = Provider<bool>((ref) {
  final login = ref.watch(loginController.state);
  return login.password.invalid && login.hasSubmitted;
});

class _PasswordInput extends HookWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read(loginController).passwordChanged(password),
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

class _LoginButton extends HookWidget {
  const _LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = useProvider(_loginFormStatus);
    return SizedBox(
      // specify a height, to ensure the same height for both children
      height: 75,
      child: Center(
        child: form.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                onPressed: () {
                  context.read(loginController).loginWithCredentials();
                },
                child: const Text('Login'),
              ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: const Text('CREATE ACCOUNT'),
    );
  }
}
