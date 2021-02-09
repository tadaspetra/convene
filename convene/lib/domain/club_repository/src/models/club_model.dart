import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_model.freezed.dart';

@freezed
abstract class ClubModel implements _$ClubModel {
  const factory ClubModel({
    //can't be @required because when it is first created we don't have id
    String id,
    @required String clubName,
    @required String leader,
    int nextIndexPicking,
    List<String> selectors,
    @required List<String> currentReaders,
    //TODO: add support for this later
    List<String> notifTokens,
    @required DateTime dateCreated,
    //can't be @required because when club first created we don't have the id yet
    String currentBookId,
    DateTime currentBookDue,
    String nextBookId,
    DateTime nextBookDue,
  }) = _ClubModel;
  const ClubModel._();

  factory ClubModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return ClubModel(
      id: documentSnapshot.id,
      clubName: documentSnapshot.data()["clubName"] as String ?? "Error no club name",
      leader: documentSnapshot.data()["leader"] as String ?? "Error no leader",
      nextIndexPicking: documentSnapshot.data()["nextIndexPicking"] as int ?? 0,
      selectors: (documentSnapshot.data()["selectors"] != null)
          ? documentSnapshot.data()["selectors"].cast<String>() as List<String>
          : ["Error: no selectors"],
      currentReaders: (documentSnapshot.data()["currentReaders"] != null)
          ? documentSnapshot.data()["currentReaders"].cast<String>() as List<String>
          : ["Error: no selectors"],
      notifTokens: (documentSnapshot.data()["notifTokens"] != null)
          ? documentSnapshot.data()["notifTokens"].cast<String>() as List<String>
          : <String>[],
      dateCreated: (documentSnapshot.data()["dateCreated"] as Timestamp ?? Timestamp.fromDate(DateTime(1))).toDate(),
      currentBookId: documentSnapshot.data()["currentBookId"] as String ?? "Error no current bok",
      currentBookDue: (documentSnapshot.data()["currentBookDue"] as Timestamp ?? Timestamp.fromDate(DateTime(1))).toDate(),
      nextBookId: documentSnapshot.data()["nextBookId"] as String,
      nextBookDue: (documentSnapshot.data()["nextBookDue"] as Timestamp ?? Timestamp.fromDate(DateTime(1))).toDate(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'clubName': clubName,
        'leader': leader,
        'nextIndexPicking': nextIndexPicking,
        'selectors': selectors,
        'currentReaders': currentReaders,
        'notifTokens': notifTokens,
        'dateCreated': dateCreated ?? Timestamp.fromDate(DateTime(1)), //TODO: is this best?
        'currentBookId': currentBookId,
        'currentBookDue': currentBookDue ?? Timestamp.fromDate(DateTime(1)),
        'nextBookId': nextBookId,
        'nextBookDue': nextBookDue ?? Timestamp.fromDate(DateTime(1)),
      };
}
