import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:books_finder/books_finder.dart';
import 'package:user_repository/user_repository.dart';

import '../book_repository.dart';
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
          currentPage: 0, //this object will be used to add to firestore
          pageCount: book.info.pageCount,
          coverImage: book.info.imageLinks["smallThumbnail"].toString(),
        ),
      );
    }

    return _books;
  }

  @override
  Future<void> addSoloBook(BookModel book) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    return users.doc(user.uid).collection("currentBooks").add(book.toJson());
  }

  @override
  Future<List<BookModel>> getCurrentBooks() async {
    final List<BookModel> _books = [];
    final user = await read(userRespositoryProvider).getCurrentUser();
    final books = await users
        .doc(user.uid)
        .collection("currentBooks")
        .orderBy("title")
        .get();

    for (final DocumentSnapshot book in books.docs) {
      _books.add(
        BookModel.fromDocumentSnapshot(book),
      );
    }

    return _books;
  }

  @override
  Future<void> finishBook(
      {BookModel book, double rating, String review}) async {
    final user = await read(userRespositoryProvider).getCurrentUser();

    //don't need to await, nothing is dependent on this
    users.doc(user.uid).collection("currentBooks").doc(book.id).delete();
    if (book.fromClub) {
      clubs
          .doc(book.clubId)
          .collection("books")
          .doc(book.clubBookId)
          .collection("reviews")
          .doc(user.uid)
          .set(<String, dynamic>{
        'rating': rating,
        'review': review,
      }); //TODO: rating and reviews get stored in separate places for solo books and for clubs
    }
    return users.doc(user.uid).collection("books").doc(book.id).set(book
        .copyWith(
          rating: rating,
          review: review,
          dateCompleted: DateTime.now(),
        )
        .toJson());
  }

  @override
  Future<List<BookModel>> getFinishedBooks() async {
    final List<BookModel> _books = [];
    final user = await read(userRespositoryProvider).getCurrentUser();
    final books = await users
        .doc(user.uid)
        .collection("books")
        .orderBy('dateCompleted', descending: true)
        .get();

    for (final DocumentSnapshot book in books.docs) {
      _books.add(
        BookModel.fromDocumentSnapshot(book),
      );
    }

    return _books;
  }

  @override
  Future<void> updateProgress({BookModel book, String newPage}) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    return users
        .doc(user.uid)
        .collection("currentBooks")
        .doc(book.id)
        .update(<String, dynamic>{
      'currentPage': int.parse(newPage),
    });
  }
}
