import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_repository/user_repository.dart';
import 'package:club_repository/club_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: () {
                context.read(authRepositoryProvider).logOut();
              },
              child: const Text('Sign out'),
            ),
            RaisedButton(
              onPressed: () {}, // create club function
              child: const Text("create club"),
            )
          ],
        ),
      ),
    );
  }
}