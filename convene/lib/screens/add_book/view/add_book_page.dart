import 'package:convene/providers.dart';
import 'package:convene/services/book_repository/models/book_model.dart';
import 'package:convene/services/book_repository/widgets/book_card.dart';
import 'package:convene/services/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AddBookPage());
  }

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  List<BookModel> _books = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            RaisedButton(
              onPressed: () async {
                _books = await context
                    .read(bookRepositoryProvider)
                    .searchBooks("brave new world");
                setState(() {});
              },
              child: const Text("Retrieve Books"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: _books[index],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
