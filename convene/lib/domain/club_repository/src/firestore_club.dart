import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

import 'club_repository.dart';

class FirestoreClub implements ClubRepository {
  FirestoreClub(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<void> createClub(ClubModel clubModel, BookModel bookModel) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    DocumentReference _clubRef =
        await clubs.add(clubModel.toJson()); //create club
    DocumentReference _bookRef = await _clubRef
        .collection("books")
        .add(bookModel.toJson()); //add book to club list
    //book relys on club being created and currentBookId relys on book being created
    _clubRef.update(clubModel.copyWith(currentBookId: _bookRef.id).toJson());
    //this will give personal list a different ID, but I think has to be that way, because there is
    //a possibility that it will give an ID that already exists
    await read(bookRepositoryProvider)
        .addSoloBook(bookModel); //add book to personal list
    await users
        .doc(user.uid)
        .collection("clubs")
        .doc(_clubRef.id)
        .set(clubModel.toJson()); //add club to users model
  }

  @override
  Future<List<ClubModel>> getCurrentClubs() async {
    final List<ClubModel> _clubs = [];
    final user = await read(userRespositoryProvider).getCurrentUser();
    final clubs =
        await users.doc(user.uid).collection("clubs").orderBy("clubName").get();

    for (final DocumentSnapshot club in clubs.docs) {
      _clubs.add(
        ClubModel.fromDocumentSnapshot(club),
      );
    }

    return _clubs;
  }

  @override
  Future<void> joinClub(String clubId) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    DocumentReference _clubRef = await clubs.doc(clubId);
    ClubModel _clubModel = ClubModel.fromDocumentSnapshot(await _clubRef.get());

    List<String> _newMembers = _clubModel.members;
    _newMembers.add(user.uid);

    _clubRef.update(_clubModel.copyWith(members: _newMembers).toJson());
    await users.doc(user.uid).collection("clubs").doc(_clubRef.id).set(
        _clubModel
            .copyWith(members: _newMembers)
            .toJson()); //add club to users model
  }
}
