import 'package:convene/pages/finished_book/finished_book.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
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
            Consumer(
              builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                return watch(currentUserController.state).when(data: (DatabaseUser value) {
                  return ListTile(
                    title: Text(
                      value.email ?? "no email",
                    ),
                  );
                }, error: (Object error, StackTrace stackTrace) {
                  return Container();
                }, loading: () {
                  return Container();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Finished Books'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  //TODO: this push goes against the way the app is set up, but will figure out later
                  context,
                  MaterialPageRoute<FinishedBookPage>(
                    builder: (context) => const FinishedBookPage(),
                  ),
                );
              },
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
