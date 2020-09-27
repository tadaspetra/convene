import 'package:user_repository/user_repository.dart';

abstract class ClubRepository {
  const ClubRepository();

  Future<void> createClub(DatabaseUser user);
}
