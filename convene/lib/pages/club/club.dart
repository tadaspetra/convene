import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';
import 'package:convene/config/palette.dart';

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

  Widget _displayCurrentBookInfo(ClubSet clubInfo, T Function<T>(ProviderBase<Object, T>) watch) {
    if (clubInfo.currentBook != null) {
      return Column(
        children: [
          const Text("Current Book"),
          BookCard(book: clubInfo.currentBook),
          Text("Book Due: ${clubInfo.club.currentBookDue}"),
          () {
            return watch(currentUserController.state).when(
              data: (DatabaseUser value) {
                if (!clubInfo.club.currentReaders.contains(value.uid)) {
                  return RaisedButton(
                    onPressed: () {
                      context.read(clubProvider(widget.clubid)).joinCurrentBook(clubInfo, value.uid);
                    },
                    child: const Text("Click to join book"),
                  );
                } else {
                  return const SizedBox();
                }
              },
              error: (Object error, StackTrace stackTrace) => const Text("Error retrieving next book"),
              loading: () => const CircularProgressIndicator(),
            );
          }()
        ],
      );
    } else {
      return const Text("No Book Found");
    }
  }

  Widget _displayNextBookInfo(ClubSet clubInfo, T Function<T>(ProviderBase<Object, T>) watch) {
    if (clubInfo.nextBook != null) {
      return Column(
        children: [
          const Text("Next Book"),
          BookCard(book: clubInfo.nextBook),
        ],
      );
    } else {
      return watch(currentUserController.state).when(
        data: (user) {
          if (clubInfo.club.selectors[clubInfo.club.nextIndexPicking] == user.uid) {
            return RaisedButton(
              onPressed: () {}, //TODO: Implement picking next book
              child: const Text("Pick Next Book"),
            );
          } else {
            return Text("Waiting for ${clubInfo.club.selectors[clubInfo.club.nextIndexPicking]} to pick nextasksdlslslsssd book");
          }
        },
        error: (Object error, StackTrace stackTrace) => const Text("Error retrieving next book"),
        loading: () => const CircularProgressIndicator(),
      );
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 80,
      onRefresh: () {
        return context.read(clubProvider(widget.clubid)).updateState(widget.clubid);
      },
      child: Scaffold(
        key: key,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    _copyClubId(context);
                  },
                )
              ],
              backgroundColor: Palette.lightGrey,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Consumer(
                  builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                    return watch(clubProvider(widget.clubid).state).when(data: (ClubSet value) {
                      return Column(
                        children: [
                          Text(value.club.clubName ?? "Error no club"),
                          const SizedBox(
                            height: 40,
                          ),
                          _displayCurrentBookInfo(value, watch),
                          const SizedBox(
                            height: 40,
                          ),
                          _displayNextBookInfo(value, watch),
                        ],
                      );
                    }, error: (Object error, StackTrace stackTrace) {
                      return const Text("Error retrieving Club");
                    }, loading: () {
                      return const Center(child: CircularProgressIndicator());
                    });
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
