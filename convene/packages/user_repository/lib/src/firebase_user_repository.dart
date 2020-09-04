import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:user_repository/src/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository(this.read);

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final Reader read;

  @override
  Future<void> addUser(User user) async {
    final uid = await read(userTokenProvider.future);
    return users.doc(uid).set(user.toJson());
  }

  @override
  Future<void> removeUser(User user) {
    // TODO: implement removeUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
