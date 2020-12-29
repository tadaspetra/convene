import 'package:convene/domain/book_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';

import 'models/club_model.dart';

abstract class ClubRepository {
  const ClubRepository();

  Future<void> createClub(ClubModel clubModel, BookModel bookModel);
  Future<void> joinClub(String clubId);
  Future<List<ClubModel>> getCurrentClubs();
}
