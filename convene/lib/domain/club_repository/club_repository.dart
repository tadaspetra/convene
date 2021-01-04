import 'package:convene/domain/book_repository/src/models/book_model.dart';

import 'src/models/club_model.dart';

abstract class ClubRepository {
  const ClubRepository();

  //outside of club
  Future<void> createClub(ClubModel clubModel, BookModel bookModel);
  Future<void> joinClub(String clubId);
  Future<List<ClubModel>> getCurrentClubs();
  Future<ClubModel> getSingleClub(String clubId);

  //inside club
  Future<BookModel> getCurrentBook(String clubId, String bookId);
}
