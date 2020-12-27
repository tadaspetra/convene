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
}
