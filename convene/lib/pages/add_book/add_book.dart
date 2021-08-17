import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const AddBookPage());

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController bookController = TextEditingController();

  String? searchText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Enter Book"),
                      controller: bookController,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    searchText = bookController.text;
                    setState(() {}); // TODO improve this
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget? child) {
                  return watch(searchBooksProvider(searchText ?? "harry potter")).when(
                    error: (Object error, StackTrace? stackTrace) {
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
                              cardType: CardType.search,
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
