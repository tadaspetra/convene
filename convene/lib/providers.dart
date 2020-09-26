import 'package:convene/services/book_repository/book_repository.dart';
import 'package:convene/services/book_repository/firestore_book.dart';
import 'package:convene/services/club_repository/club_repository.dart';
import 'package:convene/services/club_repository/firestore_club.dart';
import 'package:convene/services/navigation/navigation.dart';
import 'package:convene/services/navigation/navigation_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:user_repository/user_repository.dart';

/// App global providers

final currentPageProvider = StateProvider<Pages>((ref) => Pages.home);

/// Returns the current authentication state - [AuthenticationState]
final navigationProvider = Provider<NavigationState>((ref) {
  final authState = ref.watch(authStateProvider);
  final databaseUser = ref.watch(databaseUserProvider);
  final currentPage = ref.watch(currentPageProvider);

  return authState.when(
    authenticated: (user) {
      return databaseUser.when(
        data: (user) {
          if (user != null) {
            switch (currentPage.state) {
              case Pages.home:
                return const NavigationState.home();
                break;
              case Pages.addbook:
                return const NavigationState.addBook();
                break;
              default:
                return const NavigationState.error("invalid page");
            }
          } else {
            return const NavigationState.error("invalid user");
          }
        },
        loading: () => const NavigationState.loading(),
        error: (error, stack) => NavigationState.error(error),
      );
    },
    emailNotVerified: () => const NavigationState.emailNotVerified(),
    unauthenticated: () => const NavigationState.unauthenticated(),
    loading: () => const NavigationState.loading(),
    error: (error) => NavigationState.error(error),
  );
});

final bookRepositoryProvider =
    Provider<BookRepository>((ref) => FirestoreBook(ref.read));

final clubRepositoryProvider =
    Provider<ClubRepository>((ref) => FirestoreClub(ref.read));
