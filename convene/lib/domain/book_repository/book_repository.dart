import 'src/models/book_model.dart';

abstract class BookRepository {
  const BookRepository();

  Future<List<BookModel>> searchBooks(String name);
  Future<void> addBook(BookModel book);
  Future<List<BookModel>> getCurrentBooks();
  Future<void> finishBook({required BookModel book});
  Future<List<BookModel>> getFinishedBooks();
  Future<void> updateBook({required BookModel book});
  Future<void> deleteBook({required BookModel book});
}
