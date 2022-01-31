import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
Página de mis eventos guardados
*/
class MyEventsPage extends StatelessWidget {
  MyEventsPage({Key? key}) : super(key: key);

  final fb = FirebaseDatabase.instance;
  late DatabaseReference databaseReference;
  final ref = FirebaseDatabase.instance.reference().child("Users").child(FirebaseAuth.instance.currentUser!.uid).child("Events");

  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  //late final Stream<QuerySnapshot> events;

  // funcion para leer la informacion del usuario de la base de datos.
  /*void getEvents() async {

    List _events;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    final docUser = FirebaseFirestore.instance.collection('users_events').doc(user!.uid.toString()).collection('events').snapshots();
    events = FirebaseFirestore.instance.collection('users_events').doc(user!.uid.toString()).collection('events').snapshots();
    final snapshot = await docUser.get();
    if (snapshot.exists) {

      Fluttertoast.showToast(msg: snapshot.get('IT-CLAPPIT-2508').toString());
      print(snapshot.);

    }
  }*/

  Widget cardBodyView(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, bottom: 10, left: 20, right: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3.0,
        ),
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 1.0
          )
        ],
      ),
      child: Column(
          children: <Widget> [
            const SizedBox(height:15),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> events = FirebaseFirestore.instance.collection('users_events').doc(user!.uid.toString()).collection('events').snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Events"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: events,
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                    if ( snapshot.hasError) {
                      return Text('Something went wrong.');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }
                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return cardBodyView('${data.docs[index]['info_event']}');
                      }
                    );
                }
                ),
              ),

        ),
      ),
    );
  }
}