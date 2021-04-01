import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    //TODO: Requirements are low, because these are the reset password requirements
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'email',
              helperText: '',
            ),
            validator: EmailValidator(errorText: 'enter a valid email address'),
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'password',
              helperText: '',
            ),
            controller: passwordController,
            validator: passwordValidator,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                try {
                  await context
                      .read(authRepositoryProvider)
                      .logInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                } on FirebaseException catch (e) {
                  if (e.code == "too-many-requests" || e.code == "wrong-password") {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.message),
                          ElevatedButton(
                            onPressed: () async {
                              await context.read(authRepositoryProvider).resetPassword(emailController.text);
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text("Check your email"),
                                duration: Duration(seconds: 5),
                              ));
                            },
                            child: const Text("Send Reset Password Email"),
                          )
                        ],
                      ),
                      duration: const Duration(seconds: 10),
                    ));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(e.message),
                      duration: const Duration(seconds: 2),
                    ));
                  }
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Login"),
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                //TODO: this push goes against the way the app is set up, but will figure out later
                context,
                MaterialPageRoute<SignUpPage>(
                  builder: (context) => const SignUpPage(),
                ),
              );
            },
            child: const Text("Don't have an account? Sign Up!"),
          )
        ],
      ),
    );
  }
}
