import 'package:authentication_repository/authentication_repository.dart'; //What are we going to do about dependencies like this?
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

import '../book_repository.dart';

class Books implements BookRepository {
  Books(this.read);

  Reader read;

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');

  @override
  Future<void> addBook() {
    // TODO: implement addBook
    throw UnimplementedError();
  }
}
