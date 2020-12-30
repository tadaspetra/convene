import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/book_repository/src/firestore_book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookRepositoryProvider =
    Provider<BookRepository>((ref) => FirestoreBook(ref.read));
