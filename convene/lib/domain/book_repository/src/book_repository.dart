import 'models/book_model.dart';

abstract class BookRepository {
  const BookRepository();

  Future<List<BookModel>> searchBooks(String name);
  Future<void> addSoloBook(BookModel book);
  Future<List<BookModel>> getCurrentBooks();
  Future<void> finishBook(BookModel book);
  Future<List<BookModel>> getFinishedBooks();
  Future<void> updateProgress(BookModel book, String newPage);
}
