import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

/*
Página de mis eventos guardados
*/
class MyEventsPage extends StatelessWidget {
  MyEventsPage({Key? key}) : super(key: key);

  final fb = FirebaseDatabase.instance;
  late DatabaseReference databaseReference;

  /*showData() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.reference().child("Users").child(_auth.currentUser!.uid).child("Events");
    ref.once().then((DataSnapshot dataSnapshot) {
      var keys = dataSnapshot.value.keys;
    });
  }*/

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Events"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}