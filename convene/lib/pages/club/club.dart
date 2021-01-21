import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';

class ClubPage extends StatefulWidget {
  final String clubid;

  const ClubPage({Key key, this.clubid}) : super(key: key);

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final key = GlobalKey<ScaffoldState>();
  BookModel _nextBook;

  void _copyClubId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.clubid));
    key.currentState.showSnackBar(const SnackBar(
      content: Text("Club ID Copied!"),
    ));
  }

  @override
  Future<void> didChangeDependencies() async {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      key: key,
      body: Consumer(
        builder: (BuildContext context,
            T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
          return watch(clubProvider(widget.clubid).state).when(
              data: (ClubSet value) {
            return Column(
              children: [
                Text(value.club.clubName),
                if (value.book != null) BookCard(book: value.book),
                Text("Book Due: ${value.club.currentBookDue}"),
                if (value.club.nextBookId != null) const Text("Next Book"),
                () {
                  if (_nextBook != null) {
                    return BookCard(book: _nextBook);
                  } else {
                    if (value.club.selectors[value.club.nextIndexPicking] ==
                        context.read(databaseUserProvider).when(
                              data: (user) => user.uid,
                              error: (Object error, StackTrace stackTrace) {},
                              loading: () {},
                            )) {
                      return RaisedButton(
                        onPressed: () {}, //TODO: Implement picking next book
                        child: const Text("Pick Next Book"),
                      );
                    }
                    return Text(
                        "Waiting for ${value.club.selectors[value.club.nextIndexPicking]} to pick next book");
                  }
                }()
              ],
            );
          }, error: (Object error, StackTrace stackTrace) {
            return const Text("Error retrieving Club");
          }, loading: () {
            return const CircularProgressIndicator();
          });
        },
      ),
    );
  }
}
