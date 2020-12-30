import 'package:convene/domain/club_repository/club_repository.dart';
import 'package:convene/domain/club_repository/src/firestore_club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clubRepositoryProvider =
    Provider<ClubRepository>((ref) => FirestoreClub(ref.read));
