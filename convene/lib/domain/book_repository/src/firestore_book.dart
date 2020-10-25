import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:books_finder/books_finder.dart';

import 'book_repository.dart';
import 'models/book_model.dart';

class FirestoreBook implements BookRepository {
  FirestoreBook(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  /// this function might be doing too much, but I thought that it would be nice for our app
  /// to not rely on the book_finder package
  @override
  Future<List<BookModel>> searchBooks(String name) async {
    final List<BookModel> _books = [];
    final books = await queryBooks(
      name,
      maxResults: 20, //TODO: How many books do we want to display
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );

    for (final Book book in books) {
      _books.add(
        BookModel(
          title: book.info.title,
          authors: book.info.authors,
          pageCount: book.info.pageCount,
          coverImage: book.info.imageLinks["smallThumbnail"],
        ),
      );
    }

    return _books;
  }

  @override
  Future<void> addSoloBook(String name) async {
    final books = await queryBooks(
      name,
      maxResults: 3,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
  }
}
