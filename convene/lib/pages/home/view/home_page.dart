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
          Consumer(
            builder: (BuildContext context,
                T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
              final Future<List<BookModel>> books =
                  watch(bookRepositoryProvider).getCurrentBooks();
              books.whenComplete(() async {
                _currentBooks = await books;
                if (mounted) {
                  //TODO: Is this the best way to do it?
                  setState(() {});
                }
              });
              return Books(_currentBooks ?? <BookModel>[]);
            },
          ),
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
