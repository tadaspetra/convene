import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinClubPage extends StatefulWidget {
  const JoinClubPage({Key? key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const JoinClubPage());

  @override
  _JoinClubPageState createState() => _JoinClubPageState();
}

class _JoinClubPageState extends State<JoinClubPage> {
  final TextEditingController _clubId = TextEditingController();
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Text('Join Club'),
            TextField(
              controller: _clubId,
              decoration: const InputDecoration(labelText: "Enter Group ID"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read(clubLogic).joinClub(_clubId.text);
                Navigator.pop(context);
              },
              child: const Text("Join Club"),
            )
          ],
        ),
      ),
    );
  }
}
