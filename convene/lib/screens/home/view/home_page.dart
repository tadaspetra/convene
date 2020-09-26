import 'package:convene/screens/home/widgets/add_drawer.dart';
import 'package:convene/screens/home/widgets/books.dart';
import 'package:convene/screens/home/widgets/clubs.dart';
import 'package:convene/screens/home/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

/// If you want to use Hooks, you need to create a separate stateless widget for that,
/// since for a drawer you need to have a stateful widget. Is there a better way around this?
class HomePage extends StatefulWidget {
  const HomePage();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeScaffoldKey,
      body: Center(
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _homeScaffoldKey.currentState.openDrawer();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _homeScaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ],
              ),
            ),
            Books(),
            Clubs(),
          ],
        ),
      ),
      drawer: const MenuDrawer(),
      endDrawer: const AddDrawer(),
    );
  }
}
