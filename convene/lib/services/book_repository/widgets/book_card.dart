import 'package:convene/services/book_repository/models/book_model.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
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
          Image.network(
            book.coverImage.toString(),
            width: 80,
          ),
          Column(
            children: [
              Text(book.title),
              Text(book.authors[0]),
              Text(book.pageCount.toString()),
            ],
          )
        ],
      ),
    );
  }
}
