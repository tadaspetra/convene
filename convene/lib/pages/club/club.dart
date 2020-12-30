import 'package:convene/domain/club_repository/src/models/club_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClubPage extends StatefulWidget {
  final ClubModel club;

  const ClubPage({Key key, this.club}) : super(key: key);

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final key = new GlobalKey<ScaffoldState>();
  void _copyGroupId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.club.id));
    key.currentState.showSnackBar(SnackBar(
      content: Text("Copied!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.club.clubName),
          RaisedButton(
            onPressed: () => _copyGroupId(context),
            child: Text("Copy Group ID"),
          )
        ],
      ),
    );
  }
}
