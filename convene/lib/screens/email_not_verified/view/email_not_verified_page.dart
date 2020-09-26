import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailNotVerifiedPage extends StatelessWidget {
  const EmailNotVerifiedPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const EmailNotVerifiedPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to verify your email :)'),
            RaisedButton(
              onPressed: () {
                context.read(authRepositoryProvider).emailVerified();
              },
              child: const Text("Verified"),
            )
          ],
        ),
      ),
    );
  }
}
