import 'package:convene/domain/book_repository/book_repository.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Text(book.authors[0]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
