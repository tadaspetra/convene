import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/firestore_club.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:user_repository/user_repository.dart';

final currentClubsProvider = StreamProvider.autoDispose<List<ClubModel>>((ref) {
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

  Future<void> addSelector(String clubId, DatabaseUser user) async {
    await read(clubRepositoryProvider).addNewSelector(clubId, user);
  }

  Future<void> removeSelector(String clubId, String uid) async {
    await read(clubRepositoryProvider).removeSelector(clubId, uid);
  }
}

final clubController = StateNotifierProvider.autoDispose.family<CurrentClub, String>((ref, clubid) {
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
      final ClubModel club = await read(clubRepositoryProvider).getSingleClub(id);
      final BookModel currentBook = await read(clubRepositoryProvider).getCurrentBook(clubid, club.currentBookId);
      BookModel nextBook;
      if (club.nextBookId != null) {
        nextBook = await read(clubRepositoryProvider).getCurrentBook(clubid, club.nextBookId);
      }
      state = AsyncData(ClubSet(
        club: club,
        currentBook: currentBook,
        nextBook: nextBook,
      ));
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }

  Future<void> updateState(String clubid) async {
    _getInfo(clubid);
  }

  Future<void> joinCurrentBook(ClubSet clubInfo, String uid) async {
    await read(currentBooksController).addBook(book: clubInfo.currentBook.copyWith(clubBookId: clubInfo.club.id));
    await read(clubRepositoryProvider).addCurrentReader(clubInfo.club.id, uid);
    await updateState(clubInfo.club.id); //need to update the UI with the current club updates
  }

  Future<void> pickNextBook(ClubSet clubInfo, DateTime nextBookDue, BookModel nextBook) async {
    await read(clubRepositoryProvider).addNextBook(clubInfo.club.id, nextBookDue, nextBook);
    await updateState(clubInfo.club.id); //need to update the UI with the current club updates
  }
}

final selectorsController = StreamProvider.autoDispose.family<List<DatabaseUser>, String>((ref, clubid) {
  return ref.watch(clubRepositoryProvider).getClubSelectors(clubid);
});

final membersController = FutureProvider.autoDispose.family<List<DatabaseUser>, String>((ref, clubid) {
  return ref.read(clubRepositoryProvider).getClubMembers(clubid);
});
