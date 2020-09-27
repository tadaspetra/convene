import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookRepositoryProvider =
    Provider<BookRepository>((ref) => FirestoreBook(ref.read));
