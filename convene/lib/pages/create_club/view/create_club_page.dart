import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/global_widgets/book_card.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/club_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_repository/user_repository.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({Key key}) : super(key: key);

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const CreateClubPage());

  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  TextEditingController _clubName = TextEditingController();
  TextEditingController bookController = TextEditingController();
  BookCard _firstBook;
  List<BookModel> _books = [];
  DatabaseUser currentUser;
  DateTime _selectedDate = DateTime.now();

  initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedDate.hour, 0, 0, 0, 0);
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
            0,
            0,
            0,
            0,
          );
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
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
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Scaffold(
                body: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Enter Book"),
                              controller: bookController,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            _books = await context
                                .read(bookRepositoryProvider)
                                .searchBooks(bookController.text);
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
                  BackButton(
                      onPressed: () =>
                          context.read(currentPageProvider).state = Pages.home),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _clubName,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Club Name"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_firstBook != null) Text("First Book"),
            _firstBook ?? Container(),
            RaisedButton(
              onPressed: () async {
                await searchDialog(context);
                setState(() {});
              },
              child: _firstBook != null
                  ? Text("Change book")
                  : Text("Add initial book"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "First book due date:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
            Text(DateFormat("H:00").format(_selectedDate)),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text("Change Date"),
                    onPressed: () => _selectDate(),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text("Change Time"),
                    onPressed: () => _selectTime(),
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: () {
                context.read(clubRepositoryProvider).createClub(
                      ClubModel(
                        clubName: _clubName.text,
                        leader: currentUser.uid,
                        selectors: [currentUser.uid],
                        members: [
                          currentUser.uid
                        ], //TODO: error checking to make sure user here
                        dateCreated: DateTime.now(),
                        //currentBookId needs to be done within createClub function
                        currentBookDue: _selectedDate,
                      ),
                      _firstBook.book,
                    );
                context.read(currentPageProvider).state = Pages.home;
              },
              child: const Text("Create Club"),
            )
          ],
        ),
      ),
    );
  }
}
