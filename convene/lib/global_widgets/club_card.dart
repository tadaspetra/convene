import 'package:convene/domain/book_repository/book_repository.dart';
import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/domain/navigation/navigation.dart';
import 'package:convene/providers/book_provider.dart';
import 'package:convene/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubCard extends StatelessWidget {
  final ClubModel club;

  const ClubCard({
    Key key,
    this.club,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog<Widget>(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 30),
          child: Scaffold(
            body: ListView(
              children: [
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read(currentPageProvider).state = Pages.home;
                    },
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: DisplayClubCard(club: club),
    );
  }
}

class DisplayClubCard extends StatelessWidget {
  const DisplayClubCard({
    Key key,
    this.club,
  }) : super(key: key);

  final ClubModel club;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            spreadRadius: -5,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      club.clubName,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
