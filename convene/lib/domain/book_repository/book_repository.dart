import 'src/models/book_model.dart';

abstract class BookRepository {
  const BookRepository();

  Future<List<BookModel>> searchBooks(String name);
  Future<void> addBook(BookModel book);
  Future<List<BookModel>> getCurrentBooks();
  Future<void> finishBook({BookModel book});
  Future<List<BookModel>> getFinishedBooks();
  Future<void> updateBook({BookModel book});
}
