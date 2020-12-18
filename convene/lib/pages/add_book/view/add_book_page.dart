import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const AddBookPage());

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController bookController = TextEditingController();
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Enter Book"),
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
