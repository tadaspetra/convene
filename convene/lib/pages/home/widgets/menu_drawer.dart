import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(databaseUserProvider);
    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text(
                user.when(
                    data: (config) => config.name ?? "no name",
                    loading: () => "loading..",
                    error: (err, stack) => "error"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: () {
                context.read(authRepositoryProvider).logOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
