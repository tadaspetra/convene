import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Spacer(flex: 3),
          Image.asset(
            "assets/convene.png",
            width: screenwidth * .8,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: SignUpForm(),
            ),
          ),
          const Spacer(flex: 8),
        ],
      ),
    );
  }
}
