import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}
