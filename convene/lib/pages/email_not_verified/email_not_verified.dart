import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailNotVerifiedPage extends StatelessWidget {
  const EmailNotVerifiedPage({Key? key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const EmailNotVerifiedPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to verify your email :)'),
            ElevatedButton(
              onPressed: () {
                context.read(authRepositoryProvider).emailVerified();
              },
              child: const Text("Verified"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read(authRepositoryProvider).logOut();
              },
              child: const Text(
                "Logout",
              ), // TODO: add a better solution. Adding the logout for testing purposes
            )
          ],
        ),
      ),
    );
  }
}
