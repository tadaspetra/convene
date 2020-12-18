import 'package:convene/config/palette.dart';
import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/pages/home/widgets/add_drawer.dart';
import 'package:convene/pages/home/widgets/books.dart';
import 'package:convene/pages/home/widgets/clubs.dart';
import 'package:convene/pages/home/widgets/menu_drawer.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// If you want to use Hooks, you need to create a separate stateless widget for that,
/// since for a drawer you need to have a stateful widget. Is there a better way around this?
class HomePage extends StatefulWidget {
  const HomePage();

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey();
  List<BookModel> _currentBooks;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: maybe using a future builder or some riverpod thing is better
    _currentBooks =
        await context.read(bookRepositoryProvider).getCurrentBooks();
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeScaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _homeScaffoldKey.currentState.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _homeScaffoldKey.currentState.openEndDrawer();
                },
              ),
            ],
            backgroundColor: Palette.lightGrey,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("books"),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ],
            ),
          ),
          Books(_currentBooks ?? <BookModel>[]),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 80,
                    ),
                    Text("clubs"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      endDrawer: const AddDrawer(),
    );
  }
}
