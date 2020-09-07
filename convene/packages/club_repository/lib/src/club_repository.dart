import 'package:authentication_repository/authentication_repository.dart'; //What are we going to do about dependencies like this?
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

class ClubRepository {
  ClubRepository(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');

  Future<void> createClub(DatabaseUser user) async {
    final uid = await read(userUidProvider.future);
    return clubs.doc().collection("users").doc(uid).set(user.toJson());
  }
}
