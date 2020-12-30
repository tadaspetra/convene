import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishedBookPage extends ConsumerWidget {
  const FinishedBookPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const FinishedBookPage());

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final books = watch(bookRepositoryProvider).getFinishedBooks();
    return Scaffold(
      body: FutureBuilder(
        future: books,
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount:
                snapshot.data.length + 1, //TODO this is ugly do it with slivers
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                          onPressed: () => context
                              .read(currentPageProvider)
                              .state = Pages.home),
                    ],
                  ),
                );
              }
              return BookCard(
                book: snapshot.data[index - 1],
                cardType: CardType.finished,
                //TODO: this displays "done button", need to add another state
              );
            },
          );
        },
      ),
    );
  }
}
