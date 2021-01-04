import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/book_repository/src/firestore_book.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final bookRepositoryProvider =
    Provider<BookRepository>((ref) => FirestoreBook(ref.read));

final bookProvider = StateNotifierProvider<BookList>((ref) {
  return BookList(ref.read);
});

class BookList extends StateNotifier<List<BookModel>> {
  BookList(this.read) : super(<BookModel>[]);

  /// The `ref.read` function
  final Reader read;

  Future<void> updateList() async {
    state = await read(bookRepositoryProvider).getCurrentBooks();
  }
}
