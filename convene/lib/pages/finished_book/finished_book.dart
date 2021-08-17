import 'package:convene/config/palette.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishedBookPage extends ConsumerWidget {
  const FinishedBookPage({Key? key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const FinishedBookPage());

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Palette.lightGrey,
          ),
          Consumer(
            builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget? child) {
              return watch(finishedBooksProvider).when(
                error: (Object error, StackTrace? stackTrace) {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
                  );
                },
                loading: () {
                  return SliverList(
                    delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())]),
                  );
                },
                data: (List<BookModel> value) {
                  if (value.isEmpty) {
                    return SliverList(
                      delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return BookCard(
                            book: value[index],
                            cardType: CardType.finished,
                          );
                        },
                        childCount: value.length,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
