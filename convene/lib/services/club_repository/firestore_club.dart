import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/services/club_repository/club_repository.dart';
import 'package:riverpod/riverpod.dart';

import 'package:user_repository/user_repository.dart';

class FirestoreClub implements ClubRepository {
  FirestoreClub(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');

  @override
  Future<void> createClub(DatabaseUser user) async {
    final user = await read(userRespositoryProvider).getCurrentUser();
    return clubs.doc().collection("users").doc(user.uid).set(user.toJson());
  }
}
