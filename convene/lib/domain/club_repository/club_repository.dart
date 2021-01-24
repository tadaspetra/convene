import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:user_repository/user_repository.dart';

import 'src/models/club_model.dart';

abstract class ClubRepository {
  const ClubRepository();

  //outside of club
  Future<void> createClub(ClubModel clubModel, BookModel bookModel);
  Future<void> joinClub(String clubId);
  Stream<List<ClubModel>> getCurrentClubs(DatabaseUser user);
  Future<ClubModel> getSingleClub(String clubId);

  //inside club
  Future<BookModel> getCurrentBook(String clubId, String bookId);
  Future<void> addCurrentReader(String clubId, String userUid);
}
