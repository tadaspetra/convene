import 'package:authentication_repository/authentication_repository.dart'; //What are we going to do about dependencies like this?
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_repository/club_repository.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

class FirestoreClub implements ClubRepository {
  FirestoreClub(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');

  @override
  Future<void> createClub(DatabaseUser user) async {
    final uid = await read(userUidProvider.future);
    return clubs.doc().collection("users").doc(uid).set(user.toJson());
  }
}
