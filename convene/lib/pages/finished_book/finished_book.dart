import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishedBookPage extends ConsumerWidget {
  const FinishedBookPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const FinishedBookPage());

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (BuildContext context,
            T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
          return watch(finishedBooksProvider).when(
            error: (Object error, StackTrace stackTrace) {
              return const Text("Error retrieving books");
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            data: (List<BookModel> value) {
              if (value.isEmpty) {
                return Container();
              } else {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return BookCard(
                      book: value[index],
                      cardType: CardType.finished,
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
