import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/pages/club/club.dart';
import 'package:flutter/material.dart';

class ClubCard extends StatelessWidget {
  final ClubModel club;

  const ClubCard({
    Key key,
    this.club,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        //TODO: this push goes against the way the app is set up, but will figure out later
        context,
        MaterialPageRoute<ClubPage>(
          builder: (context) => ClubPage(
            club: club,
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
