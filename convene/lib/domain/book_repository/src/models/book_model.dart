import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class BookModel implements _$BookModel {
  const factory BookModel({
    String? id,
    required String title,
    required List<String> authors, //some books have multiple
    int? currentPage,
    int? pageCount,
    String? coverImage,
    DateTime? dateCompleted,
    double? rating,
    String? review,
    bool? fromClub,
    String? clubName,
    String? clubId,
    String? clubBookId,
  }) = _BookModel;
  const BookModel._();

  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);

  factory BookModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return BookModel(
      id: documentSnapshot.id, // Did we plan to make the uid the document id?
      title: documentSnapshot.data() != null ? documentSnapshot.data()!["title"] as String : "Error: no title",
      authors: (documentSnapshot.data()!["authors"].length != 0) // TODO: this might give errors...maybe
          ? documentSnapshot.data()!["authors"].cast<String>() as List<String>
          : ["Error: no author"],
      currentPage: documentSnapshot.data() != null ? documentSnapshot.data()!["currentPage"] as int : 0,
      pageCount: documentSnapshot.data() != null ? documentSnapshot.data()!["pageCount"] as int : 0,
      coverImage: documentSnapshot.data() != null ? documentSnapshot.data()!["coverImage"] as String : "noimage",
      dateCompleted:
          (documentSnapshot.data() != null ? (documentSnapshot.data()!["dateCompleted"] as Timestamp) : Timestamp.fromDate(DateTime(1)))
              .toDate(),
      rating: documentSnapshot.data() != null ? documentSnapshot.data()!["rating"] as double : 0,
      review: documentSnapshot.data() != null ? documentSnapshot.data()!["review"] as String : "Error: no review",
      fromClub: documentSnapshot.data() != null ? documentSnapshot.data()!["fromClub"] as bool : false,
      clubName: documentSnapshot.data() != null ? documentSnapshot.data()!["clubName"] as String : "Error: no club name",
      clubId: documentSnapshot.data() != null ? documentSnapshot.data()!["clubId"] as String : "Error: no club Id",
      clubBookId: documentSnapshot.data() != null ? documentSnapshot.data()!["clubBookId"] as String : "Error: no club book Id",
    );
  }

  // Map<String, dynamic> toJson() => <String, dynamic>{
  // 'title': ,
  // 'authors': authors,
  // 'currentPage': currentPage,
  // 'pageCount': pageCount,
  // 'coverImage': coverImage,
  // 'dateCompleted': dateCompleted ?? Timestamp.fromDate(DateTime(1)), //TODO: how to do this maybe set to 0 and check on return
  // 'rating': rating,
  // 'review': review,
  // 'fromClub': fromClub,
  // 'clubName': clubName,
  // 'clubId': clubId,
  // 'clubBookId': clubBookId,
  //     };
}
