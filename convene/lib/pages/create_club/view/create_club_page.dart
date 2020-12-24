import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const CreateClubPage());

  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  TextEditingController _clubName = TextEditingController();
  TextEditingController bookController = TextEditingController();
  BookCard _firstBook;
  List<BookModel> _books = [];

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> searchDialog(BuildContext context) {
      return showDialog<Widget>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Scaffold(
                body: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Enter Book"),
                              controller: bookController,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            _books = await context
                                .read(bookRepositoryProvider)
                                .searchBooks(bookController.text);
                            setState(() {}); // TODO improve this
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _firstBook = BookCard(
                                book: _books[index],
                              );

                              Navigator.pop(context);
                            },
                            child: BookCard(
                              book: _books[index],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _clubName,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Club Name"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_firstBook != null) Text("First Book"),
            _firstBook ?? Container(),
            RaisedButton(
              onPressed: () async {
                await searchDialog(context);
                setState(() {});
              },
              child: _firstBook != null
                  ? Text("Change book")
                  : Text("Add initial book"),
            ),
            RaisedButton(
              onPressed: () {},
              child: const Text("Create Club"),
            )
          ],
        ),
      ),
    );
  }
}
