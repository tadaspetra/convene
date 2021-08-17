import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:books_finder/books_finder.dart';
import 'package:user_repository/user_repository.dart';

import '../book_repository.dart';
import 'models/book_model.dart';

// access to repository inteface. Should not be touched in UI
final bookRepositoryProvider = Provider<BookRepository>((ref) => FirestoreBook(ref.read));

class FirestoreBook implements BookRepository {
  FirestoreBook(this.read);

  Reader read;

  final CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  /// this function might be doing too much, but I thought that it would be nice for our app
  /// to not rely on the book_finder package
  @override
  Future<List<BookModel>> searchBooks(String name) async {
    final List<BookModel> _books = [];
    final books = await queryBooks(name,
        maxResults: 20, //TODO: How many books do we want to display
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
        reschemeImageLinks: true);

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
  Future<void> addBook(BookModel book) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    await users.doc(user.uid).collection("currentBooks").add(book.toJson());
  }

  @override
  Future<List<BookModel>> getCurrentBooks() async {
    final List<BookModel> _books = [];
    final user = await read(userRespositoryProvider).getCurrentUser();
    final books = await users.doc(user.uid).collection("currentBooks").orderBy("title").get();

    for (final DocumentSnapshot book in books.docs) {
      _books.add(
        BookModel.fromDocumentSnapshot(book),
      );
    }

    return _books;
  }

  @override
  Future<void> finishBook({required BookModel book}) async {
    final user = await read(userRespositoryProvider).getCurrentUser();

    //don't need to await, nothing is dependent on this
    await users.doc(user.uid).collection("currentBooks").doc(book.id).delete();
    if (book.fromClub!) {
      await clubs.doc(book.clubId).collection("books").doc(book.clubBookId).collection("reviews").doc(user.uid).set(<String, dynamic>{
        'rating': book.rating,
        'review': book.review,
      }); //TODO: rating and reviews get stored in separate places for solo books and for clubs
    }
    return users.doc(user.uid).collection("books").doc(book.id).set(book
        .copyWith(
          dateCompleted: DateTime.now(),
        )
        .toJson());
  }

  @override
  Future<List<BookModel>> getFinishedBooks() async {
    final List<BookModel> _books = [];
    final user = await read(userRespositoryProvider).getCurrentUser();
    final books = await users.doc(user.uid).collection("books").orderBy('dateCompleted', descending: true).get();

    for (final DocumentSnapshot book in books.docs) {
      _books.add(
        BookModel.fromDocumentSnapshot(book),
      );
    }

    return _books;
  }

  @override
  Future<void> updateBook({required BookModel book}) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    return users.doc(user.uid).collection("currentBooks").doc(book.id).update(<String, dynamic>{
      'currentPage': book.currentPage,
    });
  }

  @override
  Future<void> deleteBook({required BookModel book}) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    return users.doc(user.uid).collection("currentBooks").doc(book.id).delete();
  }
}
