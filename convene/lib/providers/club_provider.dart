import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/firestore_club.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:user_repository/user_repository.dart';

final currentClubsProvider = StreamProvider<List<ClubModel>>((ref) {
  return ref.watch(clubRepositoryProvider).getCurrentClubs(
        ref.watch(currentUserController.state).when(
          data: (DatabaseUser value) {
            return value;
          },
          error: (Object error, StackTrace stackTrace) {
            return DatabaseUser(uid: null, email: null);
          },
          loading: () {
            return DatabaseUser(uid: null, email: null);
          },
        ),
      );
});

final clubLogic = Provider.autoDispose<ClubLogic>((ref) {
  return ClubLogic(ref.read);
});

class ClubLogic {
  Reader read;
  ClubLogic(this.read);

  Future<void> createClub(ClubModel clubModel, BookModel bookModel) async {
    await read(clubRepositoryProvider).createClub(clubModel, bookModel);
  }

  Future<void> joinClub(String clubId) async {
    await read(clubRepositoryProvider).joinClub(clubId);
  }
}

final clubProvider = StateNotifierProvider.autoDispose
    .family<CurrentClub, String>((ref, clubid) {
  return CurrentClub(ref.read, clubid);
});

class CurrentClub extends StateNotifier<AsyncValue<ClubSet>> {
  String clubid;
  CurrentClub(this.read, this.clubid) : super(const AsyncLoading()) {
    _getInfo(clubid);
  }

  /// The `ref.read` function
  final Reader read;

  Future<void> _getInfo(String id) async {
    try {
      final ClubModel club =
          await read(clubRepositoryProvider).getSingleClub(id);
      final BookModel book = await read(clubRepositoryProvider)
          .getCurrentBook(clubid, club.currentBookId);
      state = AsyncData(ClubSet(club: club, book: book));
    } catch (e, st) {
      return AsyncError<Exception>(e, st);
    }
  }
}
