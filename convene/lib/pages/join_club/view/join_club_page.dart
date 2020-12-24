import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinClubPage extends StatelessWidget {
  const JoinClubPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const JoinClubPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                      onPressed: () =>
                          context.read(currentPageProvider).state = Pages.home),
                ],
              ),
            ),
            const Text('Join Club'),
          ],
        ),
      ),
    );
  }
}
