import 'package:convene/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';

class LoginForm extends StatelessWidget {
  const LoginForm();

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
              context
                  .read(authRepositoryProvider)
                  .logInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
            },
            child: Text("Login"),
          ),
          RaisedButton(
            child: Text("Sign Up"),
            onPressed: () {
              Navigator.push(
                //TODO: this push goes against the way the app is set up, but will figure out later
                context,
                MaterialPageRoute<SignUpPage>(
                  builder: (context) => SignUpPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
