import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //stream: Auth(auth: auth).user, //Auth stream should go here
        // builder: (_, AsyncSnapshot<User> user) {
        //   if (user.connectionState == ConnectionState.active) {
        //     if (user.data?.uid == null) {
        //       return Login(
        //         auth: auth,
        //         firestore: firestore,
        //       );
        //     } else {
        //       return Home(
        //         auth: auth,
        //         firestore: firestore,
        //       );
        //     }
        //   } else {
        //     return const Scaffold(
        //       body: Center(
        //         child: Text("loading..."),
        //       ),
        //     );
        //   }
        // },
        );
  }
}
