import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository(this.read);

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final Reader read;

  @override
  Future<void> addUser(DatabaseUser user) async {
    final uid = await read(userUidProvider.future);
    return users.doc(uid).set(user.toJson());
  }

  @override
  Future<void> removeUser(DatabaseUser user) {
    // TODO: implement removeUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(DatabaseUser user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
