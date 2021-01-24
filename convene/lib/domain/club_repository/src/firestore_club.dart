import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

import '../club_repository.dart';

// access to repository inteface. Should not be touched in UI
final clubRepositoryProvider =
    Provider.autoDispose<ClubRepository>((ref) => FirestoreClub(ref.read));

class FirestoreClub implements ClubRepository {
  FirestoreClub(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Stream<List<ClubModel>> getCurrentClubs(DatabaseUser user) {
    return users
        .doc(user.uid)
        .collection("clubs")
        .orderBy("clubName")
        .snapshots()
        .map<List<ClubModel>>((querySnapshot) {
      final List<ClubModel> _clubs = [];
      for (final DocumentSnapshot club in querySnapshot.docs) {
        _clubs.add(
          ClubModel.fromDocumentSnapshot(club),
        );
      }
      return _clubs;
    });
  }

  @override
  Future<void> createClub(ClubModel clubModel, BookModel bookModel) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    final DocumentReference _clubRef =
        await clubs.add(clubModel.toJson()); //create club
    final DocumentReference _bookRef = await _clubRef.collection("books").add(
        bookModel
            .copyWith(clubId: _clubRef.id)
            .toJson()); //add book to club list
    //book relys on club being created and currentBookId relys on book being created
    _clubRef.update(clubModel.copyWith(currentBookId: _bookRef.id).toJson());
    //this will give personal list a different ID, but I think has to be that way, because there is
    //a possibility that it will give an ID that already exists
    await read(currentBooksController).addBook(
        book: bookModel.copyWith(
            clubId: _clubRef.id,
            clubBookId: _bookRef.id)); //add book to personal list
    await users
        .doc(user.uid)
        .collection("clubs")
        .doc(_clubRef.id)
        .set(clubModel.toJson()); //add club to users model
  }

  @override
  Future<void> joinClub(String clubId) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    final DocumentReference _clubRef = clubs.doc(clubId);
    final ClubModel _clubModel =
        ClubModel.fromDocumentSnapshot(await _clubRef.get());

    final List<String> _newMembers = _clubModel.members;
    _newMembers.add(user.uid);

    _clubRef.update(_clubModel.copyWith(members: _newMembers).toJson());
    await users.doc(user.uid).collection("clubs").doc(_clubRef.id).set(
        _clubModel
            .copyWith(members: _newMembers)
            .toJson()); //add club to users model
  }

  @override
  Future<BookModel> getCurrentBook(String clubId, String bookId) async {
    DocumentSnapshot doc =
        await clubs.doc(clubId).collection("books").doc(bookId).get();
    return BookModel.fromDocumentSnapshot(doc);
  }

  @override
  Future<ClubModel> getSingleClub(String clubId) async {
    return ClubModel.fromDocumentSnapshot(await clubs.doc(clubId).get());
  }

  @override
  Future<void> addCurrentReader(String clubId, String userUid) async {
    await clubs.doc(clubId).update(<String, dynamic>{
      "currentReaders": FieldValue.arrayUnion(<String>[userUid]),
    }); //
  }
}
