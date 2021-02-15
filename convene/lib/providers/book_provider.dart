import 'package:convene/domain/book_repository/src/firestore_book.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

// list of books from search
final searchBooksProvider = FutureProvider.autoDispose.family<List<BookModel>, String>((ref, name) {
  if (name == null) {
    return Future.value([]);
  }
  return ref.read(bookRepositoryProvider).searchBooks(name);
});

// list of finished books
final finishedBooksProvider = FutureProvider.autoDispose<List<BookModel>>((ref) {
  return ref.watch(bookRepositoryProvider).getFinishedBooks();
});

// list of books being currently read by the user
final currentBooksController = StateNotifierProvider.autoDispose<CurrentBookList>((ref) {
  return CurrentBookList(ref.read);
});

class CurrentBookList extends StateNotifier<AsyncValue<List<BookModel>>> {
  CurrentBookList(this.read) : super(const AsyncLoading()) {
    _getBooks();
  }

  final Reader read;

  Future<void> _getBooks() async {
    try {
      final List<BookModel> books = await read(bookRepositoryProvider).getCurrentBooks();
      state = AsyncData(books);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }

  Future<void> addBook({BookModel book}) async {
    try {
      await read(bookRepositoryProvider).addBook(book);
      final List<BookModel> books = await read(bookRepositoryProvider).getCurrentBooks();
      state = AsyncData(books);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }

  Future<void> updateBook({BookModel book}) async {
    try {
      await read(bookRepositoryProvider).updateBook(book: book);
      final List<BookModel> books = await read(bookRepositoryProvider).getCurrentBooks();
      state = AsyncData(books);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }

  Future<void> finishBook({BookModel book}) async {
    try {
      await read(bookRepositoryProvider).finishBook(book: book);
      final List<BookModel> books = await read(bookRepositoryProvider).getCurrentBooks();
      state = AsyncData(books);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }

  Future<void> deleteBook({BookModel book}) async {
    try {
      await read(bookRepositoryProvider).deleteBook(book: book);
      final List<BookModel> books = await read(bookRepositoryProvider).getCurrentBooks();
      state = AsyncData(books);
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }
}

//Provider -- interfaces, shouldnt interact with UI
//Stream, Future - will use Provider
//StateNotifier - States of the app
