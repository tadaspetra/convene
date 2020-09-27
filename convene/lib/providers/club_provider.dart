import 'package:convene/domain/club_repository/club_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final clubRepositoryProvider =
    Provider<ClubRepository>((ref) => FirestoreClub(ref.read));
