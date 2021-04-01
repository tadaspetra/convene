import 'package:convene/domain/book_repository/src/firestore_book.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_set.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/pages/club_selectors/club_selectors.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
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
  final TextEditingController _bookController = TextEditingController();
  List<BookModel> _books = [];
  BookCard _nextBook;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedDate.hour,
    );
  }

  Future<void> _selectDate() async {
    final DateTime picked =
        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
        );
      });
    }
  }

  Future _selectTime() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 23,
          initialIntegerValue: 0,
          infiniteLoop: true,
        );
      },
    ).then((int value) {
      if (value != null) {
        setState(() {
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            value,
          );
        });
      }
    });
  }

  void _copyClubId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.clubid));
    key.currentState.showSnackBar(const SnackBar(
      content: Text("Club ID Copied!"),
    ));
  }

  Widget _displayCurrentBookInfo(ClubSet clubInfo, T Function<T>(ProviderBase<Object, T>) watch) {
    if (clubInfo.currentBook != null) {
      if (!clubInfo.currentBook.title.contains("Error")) {
        return Column(
          children: [
            const Text("Current Book"),
            BookCard(book: clubInfo.currentBook),
            Text("Book Due: ${clubInfo.club.currentBookDue}"),
            () {
              return watch(currentUserController.state).when(
                data: (DatabaseUser value) {
                  if (!clubInfo.club.currentReaders.contains(value.uid)) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read(clubController(widget.clubid)).joinCurrentBook(clubInfo, value.uid);
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
        return const Text("No current book found"); // TODO: Leader needs to choose next book
      }
    } else {
      return const Text("No Book Found");
    }
  }

  Widget _displayNextBookInfo(ClubSet clubInfo, T Function<T>(ProviderBase<Object, T>) watch) {
    if (!clubInfo.currentBook.title.contains("Error")) {
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
              return Column(children: [
                if (_nextBook != null) const Text("Next Book"),
                _nextBook ?? Container(),
                ElevatedButton(
                  onPressed: () async {
                    await searchDialog(context);
                    setState(() {});
                  },
                  child: _nextBook != null ? const Text("Change book") : const Text("Pick Next Book"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Next book due date:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                Text(DateFormat("H:00").format(_selectedDate)),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(),
                        child: const Text("Change Date"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(),
                        child: const Text("Change Time"),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read(clubController(widget.clubid)).pickNextBook(clubInfo, _selectedDate, _nextBook.book);
                    context.read(clubController(widget.clubid)).updateState(widget.clubid);
                  },
                  child: const Text("Add Next Book"),
                )
              ]);
            } else {
              return Text("Waiting for ${clubInfo.club.selectors[clubInfo.club.nextIndexPicking]} to pick next book");
            }
          },
          error: (Object error, StackTrace stackTrace) => const Text("Error retrieving next book"),
          loading: () => const CircularProgressIndicator(),
        );
      }
    } else {
      return Container(); // TODO: Add Fixing error
    }
  }

  Future<Widget> searchDialog(BuildContext context) {
    return showDialog<Widget>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Scaffold(
              body: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: "Enter Book"),
                            controller: _bookController,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _books = await context.read(bookRepositoryProvider).searchBooks(_bookController.text);
                          setState(() {}); // TODO improve this
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _nextBook = BookCard(
                              book: _books[index],
                            );

                            Navigator.pop(context);
                          },
                          child: BookCard(
                            book: _books[index],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
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
        return context.read(clubController(widget.clubid)).updateState(widget.clubid);
      },
      child: Scaffold(
        key: key,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.people),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<ClubSelectorsPage>(
                        builder: (BuildContext context) => ClubSelectorsPage(
                          clubId: widget.clubid,
                        ),
                      ),
                    );
                  },
                ),
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
                    return watch(clubController(widget.clubid).state).when(data: (ClubSet value) {
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
