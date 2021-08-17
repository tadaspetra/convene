import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:user_repository/user_repository.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    //TODO: Requirements are low, because these are the reset password requirements
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signUpKey,
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
              if (signUpKey.currentState!.validate()) {
                try {
                  await context.read(authRepositoryProvider).signUp(email: emailController.text, password: passwordController.text);
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.message!),
                    duration: const Duration(seconds: 2),
                  ));
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Sign Up"),
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_forward),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
