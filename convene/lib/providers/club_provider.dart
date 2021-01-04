import 'package:convene/domain/club_repository/club_repository.dart';
import 'package:convene/domain/club_repository/src/firestore_club.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final clubRepositoryProvider =
    Provider<ClubRepository>((ref) => FirestoreClub(ref.read));

final clubProvider = StateNotifierProvider<ClubList>((ref) {
  return ClubList(ref.read);
});

class ClubList extends StateNotifier<List<ClubModel>> {
  ClubList(this.read) : super(<ClubModel>[]);

  /// The `ref.read` function
  final Reader read;

  Future<void> updateList() async {
    state = await read(clubRepositoryProvider).getCurrentClubs();
  }
}
