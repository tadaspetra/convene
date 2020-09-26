import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoFirestoreUserPage extends StatelessWidget {
  const NoFirestoreUserPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const NoFirestoreUserPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to create a user'),
            RaisedButton(
              onPressed: () {
                context.read(authRepositoryProvider).logOut();
              },
              child: const Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
