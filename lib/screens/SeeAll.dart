//Página de Events Detail
import 'package:flutter/material.dart';
import 'package:ijoin/screens/MyEventsPage.dart';

class SeeAll extends StatelessWidget {

  const SeeAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(""),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                //width: double.infinity,
                margin: const EdgeInsets.only(top: 300.0, bottom: 10),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget> [
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                            primary: Colors.white,
                            backgroundColor: Colors.redAccent,
                            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width)
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyEventsPage()),
                            //(event: event)),
                          );

                        },
                        child: Text('See All My Events', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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