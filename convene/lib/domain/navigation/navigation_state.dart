import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_state.freezed.dart';

@freezed
abstract class NavigationState with _$NavigationState {
  const factory NavigationState.home() = Home;
  const factory NavigationState.addBook() = AddBook;
  const factory NavigationState.finishedBook() = FinishedBook;
  const factory NavigationState.createClub() = CreateClub;
  const factory NavigationState.joinClub() = JoinClub;
  const factory NavigationState.emailNotVerified() = EmailNotVerified;
  const factory NavigationState.unauthenticated() = Unauthenticated;
  const factory NavigationState.loading() = Loading;
  const factory NavigationState.error(Object error) = Error;
}
