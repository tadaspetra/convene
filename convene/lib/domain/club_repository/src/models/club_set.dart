import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_set.freezed.dart';

@freezed
abstract class ClubSet implements _$ClubSet {
  const factory ClubSet({
    ClubModel club,
    BookModel book,
  }) = _ClubSet;
  const ClubSet._();
}
