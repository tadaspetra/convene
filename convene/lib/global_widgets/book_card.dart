import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CardType {
  search,
  home,
  finished,
}

class BookCard extends StatelessWidget {
  final BookModel book;
  final CardType cardType;

  const BookCard({Key key, this.book, this.cardType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (cardType) {
      case CardType.search:
        return GestureDetector(
          onTap: () => showDialog<Widget>(
            context: context,
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: ListView(
                  children: [
                    DisplayBookCard(book: book),
                    const SizedBox(height: 30),
                    const Text(
                      "Add this book to current reading?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          context.read(currentBooksController).addBook(book: book);
                          Navigator.pop(context);
                          Navigator.pop(context);
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
      case CardType.finished:
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
            child: ((book.coverImage == "noimage") || book.coverImage == null)
                //if object gets created with no cover image we set to "noimage"
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
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      book.title,
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (book.authors.isNotEmpty) Flexible(child: Text(book.authors[0])),
                  () {
                    switch (cardType) {
                      case CardType.search:
                        return Column(
                          children: [
                            Text(book.pageCount.toString()),
                          ],
                        ); //TODO: Is there something better to return here?
                        break;
                      case CardType.home:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (book.fromClub) Text("From: ${book.clubName}"),
                            Text("${(book.currentPage / book.pageCount * 100).toStringAsFixed(2)}%"),
                            UpdateButton(book: book),
                            RaisedButton(
                              onPressed: () {
                                if (!((book.clubId == null) || (book.clubId == "Error: no club Id"))) {
                                  context.read(currentBooksController).deleteBook(book: book);
                                  context.read(clubLogic).removeCurrentReader(book.clubId);
                                } else {
                                  context.read(currentBooksController).deleteBook(book: book);
                                }
                              },
                              child: const Text("Delete"),
                            )
                          ],
                        );
                        break;
                      case CardType.finished:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rating: ${book.rating}"),
                            Text("Review:  ${book.review}"),
                          ],
                        );
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

class UpdateButton extends StatelessWidget {
  const UpdateButton({
    Key key,
    @required this.book,
  }) : super(key: key);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController(text: book.currentPage.toString());
    return RaisedButton(
      onPressed: () => showDialog<Widget>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: ListView(
              children: [
                const Text(
                  "Current Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _textController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      context.read(currentBooksController).updateBook(book: book.copyWith(currentPage: int.parse(_textController.text)));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Update"),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      final TextEditingController _reviewController = TextEditingController();
                      double rating = 0;
                      showDialog<Widget>(
                        context: context,
                        builder: (_) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
                          child: Scaffold(
                            resizeToAvoidBottomInset: false, //this makes it so scaffold still appears
                            body: ListView(
                              children: [
                                const Text(
                                  "Review",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: 1,
                                  minRating: 1,
                                  allowHalfRating: true,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (newRating) {
                                    rating = newRating;
                                  },
                                ),
                                TextField(
                                  controller: _reviewController,
                                  maxLines: 6,
                                  decoration: const InputDecoration(
                                    hintText: "Add A Review",
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    context.read(currentBooksController).finishBook(
                                          book: book.copyWith(
                                            rating: rating,
                                            review: _reviewController.text,
                                          ),
                                        );
                                    if (!((book.clubId == null) || (book.clubId == "Error: no club Id"))) {
                                      context.read(clubLogic).addReview(book.clubId, book.clubBookId, _reviewController.text, rating);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("Finished Book"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: const Text("Update"),
    );
  }
}
