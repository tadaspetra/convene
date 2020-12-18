import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CardType {
  search,
  home,
  finished,
}

class BookCard extends StatelessWidget {
  final BookModel book;
  final CardType cardType;

  const BookCard({Key key, this.book, @required this.cardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (cardType) {
      case CardType.search:
        return GestureDetector(
          onTap: () => showDialog<Widget>(
            context: context,
            builder: (_) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
              child: Scaffold(
                body: ListView(
                  children: [
                    DisplayBookCard(book: book),
                    const SizedBox(height: 30),
                    const Text(
                      "Add this book to current reading?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          context
                              .read(bookRepositoryProvider)
                              .addSoloBook(book);
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
          child: DisplayBookCard(book: book, cardType: cardType),
        );
        break;
      case CardType.home:
        return DisplayBookCard(book: book, cardType: cardType);
        break;
      case CardType.finished:
        return DisplayBookCard(book: book, cardType: cardType);
        break;
      default:
        return DisplayBookCard(book: book, cardType: cardType);
        break;
    }
  }
}

class DisplayBookCard extends StatelessWidget {
  const DisplayBookCard({
    Key key,
    @required this.book,
    this.cardType,
  }) : super(key: key);

  final BookModel book;
  final CardType cardType;

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
            child: book.coverImage ==
                    "noimage" //if object gets created with no cover image we set to "noimage"
                ? Container()
                : Image.network(
                    book.coverImage,
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
                  () {
                    switch (cardType) {
                      case CardType.search:
                        return Container(); //TODO: Is there something better to return here?
                        break;
                      case CardType.home:
                        return RaisedButton(
                          onPressed: () => context
                              .read(bookRepositoryProvider)
                              .finishBook(book),
                          child: const Text("Done"),
                        );
                        break;
                      case CardType.finished:
                        return Container();
                        break;
                      default:
                        return Container();
                        break;
                    }
                  }()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
