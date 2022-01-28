//Página de Events Detail
import 'package:flutter/material.dart';
import 'package:ijoin/screens/HomePage.dart';

class EventsDetail extends StatelessWidget {
  final String text;
  //final Event event;
  const EventsDetail({Key? key, required this.text}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Events Detail"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20.0, bottom: 10, left: 20, right: 20),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget> [
                      Text(
                        //event.name,
                        text,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height:50),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(15.0),
                              primary: Colors.white,
                              backgroundColor: Colors.redAccent,
                              fixedSize: Size.fromWidth(MediaQuery.of(context).size.width)
                          ),
                          onPressed: () {
                           // _openAddEntryDialog();
                          },
                          child: Text('Save Event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}