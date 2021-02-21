import 'package:convene/pages/add_book/add_book.dart';
import 'package:convene/pages/create_club/create_club.dart';
import 'package:convene/pages/join_club/join_club.dart';
import 'package:flutter/material.dart';

class AddDrawer extends StatelessWidget {
  const AddDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Solo Book'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(builder: (context) => const AddBookPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Join a Club'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(builder: (context) => const JoinClubPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Create a Club'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push<MaterialPageRoute>(MaterialPageRoute(builder: (context) => const CreateClubPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
