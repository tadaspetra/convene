import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:convene/global_widgets/club_card.dart';
import 'package:flutter/material.dart';

class Clubs extends StatelessWidget {
  final List<ClubModel> clubs;
  const Clubs(this.clubs);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ClubCard(
            club: clubs[index],
          );
        },
        childCount: clubs.length,
      ),
    );
  }
}
