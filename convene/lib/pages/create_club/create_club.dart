import 'package:convene/domain/book_repository/src/firestore_book.dart';
import 'package:convene/domain/book_repository/src/models/book_model.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({Key key}) : super(key: key);

  static Route get route => MaterialPageRoute<void>(builder: (_) => const CreateClubPage());

  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  final TextEditingController _clubName = TextEditingController();
  final TextEditingController _bookController = TextEditingController();
  BookCard _firstBook;
  List<BookModel> _books = [];
  DatabaseUser currentUser;
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

  @override
  Future<void> didChangeDependencies() async {
    currentUser = await context.read(userRespositoryProvider).getCurrentUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                              _firstBook = BookCard(
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

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _clubName,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "Club Name"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_firstBook != null) const Text("First Book"),
            _firstBook ?? Container(),
            RaisedButton(
              onPressed: () async {
                await searchDialog(context);
                setState(() {});
              },
              child: _firstBook != null ? const Text("Change book") : const Text("Add initial book"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "First book due date:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
            Text(DateFormat("H:00").format(_selectedDate)),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () => _selectDate(),
                    child: const Text("Change Date"),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () => _selectTime(),
                    child: const Text("Change Time"),
                  ),
                ),
              ],
            ),
            Consumer(
              builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                return watch(currentUserController.state).maybeWhen(data: (DatabaseUser value) {
                  return RaisedButton(
                    onPressed: () {
                      context.read(clubLogic).createClub(
                            ClubModel(
                              clubName: _clubName.text,
                              leader: currentUser.uid,
                              selectors: [currentUser.uid],
                              currentReaders: [currentUser.uid],
                              dateCreated: DateTime.now(),
                              //currentBookId needs to be done within createClub function
                              currentBookDue: _selectedDate,
                            ),
                            _firstBook.book.copyWith(fromClub: true, clubName: _clubName.text),
                          );
                      Navigator.pop(context);
                    },
                    child: const Text("Create Club"),
                  );
                }, orElse: () {
                  return const Text("Error, can't find current user");
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
