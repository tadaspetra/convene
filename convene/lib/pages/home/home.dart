import 'package:convene/config/palette.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/pages/home/widgets/add_drawer.dart';
import 'package:convene/pages/home/widgets/books.dart';
import 'package:convene/pages/home/widgets/clubs.dart';
import 'package:convene/pages/home/widgets/menu_drawer.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey();
  @override
  void didChangeDependencies() {
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
                _homeScaffoldKey.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _homeScaffoldKey.currentState!.openEndDrawer();
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
            builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget? child) {
              return watch(currentBooksController.state).when(
                error: (Object error, StackTrace? stackTrace) {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
                  );
                },
                loading: () {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())]),
                  );
                },
                data: (List<BookModel> value) {
                  return Books(value);
                },
              );
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
          Consumer(
            builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget? child) {
              return watch(currentClubsProvider).when(
                data: (List<ClubModel> value) {
                  return Clubs(value);
                },
                error: (Object error, StackTrace? stackTrace) {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
                  );
                },
                loading: () {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())]),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      endDrawer: const AddDrawer(),
    );
  }
}
