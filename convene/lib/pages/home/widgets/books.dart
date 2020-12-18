import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:flutter/material.dart';

class Books extends StatelessWidget {
  final List<BookModel> books;
  const Books(this.books);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return BookCard(
            book: books[index],
            cardType: CardType.home,
          );
        },
        childCount: books.length,
      ),
    );
  }
}
