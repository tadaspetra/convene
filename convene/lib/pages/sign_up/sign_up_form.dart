import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: Key('loginForm_emailInput_textField'),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'email',
              helperText: '',
            ),
          ),
          TextField(
            key: const Key('loginForm_passwordInput_textField'),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'password',
              helperText: '',
            ),
            controller: passwordController,
          ),
          RaisedButton(
            onPressed: () {
              context.read(authRepositoryProvider).signUp(email: emailController.text, password: passwordController.text);
            },
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}
