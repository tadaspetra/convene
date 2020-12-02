import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';

@freezed
abstract class BookModel implements _$BookModel {
  const factory BookModel({
    String id,
    @required String title,
    @required List<String> authors, //some books have multiple
    int pageCount,
    Uri coverImage,
  }) = _Book;
  const BookModel._();

  factory BookModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return BookModel(
      id: documentSnapshot.id, // Did we plan to make the uid the document id?
      title: documentSnapshot.data()["title"] as String,
      authors: documentSnapshot.data()["authors"] as List<String>,
      pageCount: documentSnapshot.data()["pageCount"] as int,
      coverImage: documentSnapshot.data()["coverImage"] as Uri,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'authors': authors,
        'pageCount': pageCount,
        'coverImage': coverImage.toString(),
      };
}
