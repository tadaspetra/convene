import 'package:convene/domain/book_repository/src/models/book_model.dart';

import 'src/models/club_model.dart';

abstract class ClubRepository {
  const ClubRepository();

  Future<void> createClub(ClubModel clubModel, BookModel bookModel);
  Future<void> joinClub(String clubId);
  Future<List<ClubModel>> getCurrentClubs();
}
