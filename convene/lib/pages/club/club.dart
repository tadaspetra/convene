import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';

class ClubPage extends StatefulWidget {
  final ClubModel club;

  const ClubPage({Key key, this.club}) : super(key: key);

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final key = GlobalKey<ScaffoldState>();
  BookModel _currentBook;
  BookModel _nextBook;
  DatabaseUser _currentUser;

  void _copyClubId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.club.id));
    key.currentState.showSnackBar(const SnackBar(
      content: Text("Club ID Copied!"),
    ));
  }

  @override
  Future<void> didChangeDependencies() async {
    _currentBook = await context
        .read(clubRepositoryProvider)
        .getCurrentBook(widget.club.id, widget.club.currentBookId);
    if (widget.club.nextBookId != "Error no next book") {
      _nextBook = await context
          .read(clubRepositoryProvider)
          .getCurrentBook(widget.club.id, widget.club.nextBookId);
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Column(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyClubId(context),
                )
              ],
            ),
          ),
          Text(widget.club.clubName),
          if (_currentBook != null) BookCard(book: _currentBook),
          Text("Book Due: ${widget.club.currentBookDue}"),
          if (_nextBook != null) const Text("Next Book"),
          () {
            if (_nextBook != null) {
              return BookCard(book: _nextBook);
            } else {
              if (widget.club.selectors[widget.club.nextIndexPicking] ==
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
                  "Waiting for ${widget.club.selectors[widget.club.nextIndexPicking]} to pick next book");
            }
          }()
        ],
      ),
    );
  }
}
