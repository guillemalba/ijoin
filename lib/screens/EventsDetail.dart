//Página de Events Detail
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'SeeAll.dart';

class EventsDetail extends StatelessWidget {
  final String text;
  final String image;
  //final Event event;
  const EventsDetail({Key? key, required this.text, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Events Detail"),
        centerTitle: true,
      ),
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView (
            child: cardBodyView(text),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 9, right: 9),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(15.0),
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width)
          ),
          onPressed: () {
            //saveEvent();
            Fluttertoast.showToast(msg: "Event Saved Succesfully");
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeeAll()),
              //(event: event)),
            );*/
          },
          child: Text('Save Event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

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
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 1.0)
        ],
      ),
      child: Column(
        children: <Widget> [
          Image.network(image),
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

}