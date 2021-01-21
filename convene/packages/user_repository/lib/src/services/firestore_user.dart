import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:user_repository/src/models/database_user/database_user.dart';
import 'package:user_repository/src/user_repository.dart';
import 'package:user_repository/src/providers.dart';

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository(this.read);

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final Reader read;

  // @override
  // Future<void> addUser(DatabaseUser user) async {
  //   final currentUser = await read(authUserProvider.last);
  //   return users.doc(currentUser.uid).set(user.toJson());
  // }

  // @override
  // Future<void> removeUser(DatabaseUser user) {
  //   // TODO: implement removeUser
  //   throw UnimplementedError();
  // }

  @override
  Future<void> updateUser(DatabaseUser user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<DatabaseUser> getCurrentUser() async {
    final currentUser = await read(authUserProvider.last);
    return DatabaseUser.fromDocumentSnapshot(
        await users.doc(currentUser.uid).get());
  }
}
