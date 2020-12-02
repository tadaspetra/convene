import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final bool canAddToList;

  const BookCard({Key key, this.book, this.canAddToList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (canAddToList) {
      return GestureDetector(
        onTap: () => showDialog<Widget>(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
            child: Scaffold(
              body: ListView(
                children: [
                  ActualCard(book: book),
                  const SizedBox(height: 30),
                  const Text(
                    "Add this book to current reading?",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: () {
                        context.read(bookRepositoryProvider).addSoloBook(book);
                        Navigator.pop(context);
                        context.read(currentPageProvider).state = Pages.home;
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: ActualCard(book: book),
      );
    } else {
      return ActualCard(book: book);
    }
  }
}

class ActualCard extends StatelessWidget {
  const ActualCard({
    Key key,
    @required this.book,
  }) : super(key: key);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            spreadRadius: -5,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              book.coverImage.toString(),
              width: 80,
              height: 120,
              cacheWidth: 80,
              cacheHeight: 120,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      book.title,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (book.authors.isNotEmpty)
                    Flexible(child: Text(book.authors[0])),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
