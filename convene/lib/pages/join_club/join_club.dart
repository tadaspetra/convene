import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinClubPage extends StatefulWidget {
  const JoinClubPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const JoinClubPage());

  @override
  _JoinClubPageState createState() => _JoinClubPageState();
}

class _JoinClubPageState extends State<JoinClubPage> {
  TextEditingController _clubId = TextEditingController();
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
            TextField(
              controller: _clubId,
              decoration: InputDecoration(labelText: "Enter Group ID"),
            ),
            RaisedButton(
              onPressed: () {
                context.read(clubRepositoryProvider).joinClub(_clubId.text);
                context.read(currentPageProvider).state = Pages.home;
              },
              child: Text("Join Club"),
            )
          ],
        ),
      ),
    );
  }
}
