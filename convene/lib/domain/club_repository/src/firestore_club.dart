import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

import '../club_repository.dart';

// access to repository inteface. Should not be touched in UI
final clubRepositoryProvider = Provider.autoDispose<ClubRepository>((ref) => FirestoreClub(ref.read));

class FirestoreClub implements ClubRepository {
  FirestoreClub(this.read);

  Reader read;

  final CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Stream<List<ClubModel>> getCurrentClubs(DatabaseUser user) {
    return users.doc(user.uid).collection("clubs").orderBy("clubName").snapshots().map<List<ClubModel>>((querySnapshot) {
      final List<ClubModel> _clubs = [];
      for (final DocumentSnapshot club in querySnapshot.docs) {
        _clubs.add(
          ClubModel.fromDocumentSnapshot(club),
        );
      }
      return _clubs;
    });
  }

  /// TODO: Add user to member and selectors collection
  @override
  Future<void> createClub(ClubModel clubModel, BookModel bookModel) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    final DocumentReference _clubRef = await clubs.add(clubModel.toJson()); //create club
    addNewMember(_clubRef.id, user);
    addNewSelector(_clubRef.id, user);
    final DocumentReference _bookRef =
        await _clubRef.collection("books").add(bookModel.copyWith(clubId: _clubRef.id).toJson()); //add book to club list
    //book relys on club being created and currentBookId relys on book being created
    _clubRef.update(clubModel.copyWith(currentBookId: _bookRef.id).toJson());
    //this will give personal list a different ID, but I think has to be that way, because there is
    //a possibility that it will give an ID that already exists
    await read(currentBooksController)
        .addBook(book: bookModel.copyWith(clubId: _clubRef.id, clubBookId: _bookRef.id)); //add book to personal list
    await users.doc(user.uid).collection("clubs").doc(_clubRef.id).set(clubModel.toJson()); //add club to users model
  }

  /// TODO: add user to members collection
  @override
  Future<void> joinClub(String clubId) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    final DocumentReference _clubRef = clubs.doc(clubId);
    final ClubModel _clubModel = ClubModel.fromDocumentSnapshot(await _clubRef.get());

    addNewMember(_clubRef.id, user);

    await users.doc(user.uid).collection("clubs").doc(_clubRef.id).set(_clubModel.toJson()); //add club to users model
  }

  @override
  Future<BookModel> getCurrentBook(String clubId, String bookId) async {
    try {
      final DocumentSnapshot doc = await clubs.doc(clubId).collection("books").doc(bookId).get();
      return BookModel.fromDocumentSnapshot(doc);
    } catch (e) {
      return BookModel(title: "Error Finding Book", authors: ["Error"]);
    }
  }

  @override
  Future<ClubModel> getSingleClub(String clubId) async {
    return ClubModel.fromDocumentSnapshot(await clubs.doc(clubId).get());
  }

  @override
  Future<void> addCurrentReader(String clubId, String userUid) async {
    await clubs.doc(clubId).update(<String, dynamic>{
      "currentReaders": FieldValue.arrayUnion(<String>[userUid]),
    });
  }

  @override
  Future<void> addNextBook(String clubId, DateTime nextBookDue, BookModel bookModel) async {
    final DocumentReference _bookRef =
        await clubs.doc(clubId).collection("books").add(bookModel.copyWith(clubId: clubId).toJson()); //add book to club list
    await clubs.doc(clubId).update(<String, dynamic>{
      "nextBookId": _bookRef.id,
      "nextBookDue": nextBookDue,
    });
  }

  @override
  Stream<List<DatabaseUser>> getClubSelectors(String clubId) {
    return clubs.doc(clubId).collection("selectors").snapshots().map<List<DatabaseUser>>((querySnapshot) {
      final List<DatabaseUser> _selectors = [];
      for (final DocumentSnapshot selector in querySnapshot.docs) {
        _selectors.add(DatabaseUser.fromDocumentSnapshot(selector));
      }
      return _selectors;
    });
  }

  @override
  Future<List<DatabaseUser>> getClubMembers(String clubId) async {
    final QuerySnapshot query = await clubs.doc(clubId).collection("members").get();

    final List<DatabaseUser> _members = [];
    for (final DocumentSnapshot member in query.docs) {
      _members.add(DatabaseUser.fromDocumentSnapshot(member));
    }
    return _members;
  }

  /// create new member in collection
  @override
  Future<void> addNewMember(String clubId, DatabaseUser user) async {
    return clubs.doc(clubId).collection("members").doc(user.uid).set(user.toJson());
  }

  /// create new selector in collection
  @override
  Future<void> addNewSelector(String clubId, DatabaseUser user) async {
    await clubs.doc(clubId).update(<String, dynamic>{
      "selectors": FieldValue.arrayUnion(<String>[user.uid]),
    });
    return clubs.doc(clubId).collection("selectors").doc(user.uid).set(user.toJson());
  }

  /// remove from member collection, selector collection, selector array
  @override
  Future<void> removeMember(String clubId, String uid) async {
    final DocumentReference memberRef = clubs.doc(clubId).collection("members").doc(uid);
    final DocumentReference selectorRef = clubs.doc(clubId).collection("selectors").doc(uid);

    if ((await memberRef.get()).exists) {
      memberRef.delete();
    }

    if ((await selectorRef.get()).exists) {
      selectorRef.delete();
      await clubs.doc(clubId).update(<String, dynamic>{
        "selectors": FieldValue.arrayRemove(<String>[uid]),
      });
    }
  }

  // remove from selector collection, selector array
  @override
  Future<void> removeSelector(String clubId, String uid) async {
    final DocumentReference selectorRef = clubs.doc(clubId).collection("selectors").doc(uid);

    if ((await selectorRef.get()).exists) {
      selectorRef.delete();
      await clubs.doc(clubId).update(<String, dynamic>{
        "selectors": FieldValue.arrayRemove(<String>[uid]),
      });
    }
  }
}
