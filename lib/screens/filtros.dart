import 'package:flutter/material.dart';

class FiltrosScreen extends StatefulWidget {
  @override
  _FiltrosState createState() => new _FiltrosState();
}

class _FiltrosState extends State<FiltrosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add filters'),
        actions: [
          FlatButton(
              textColor: Colors.white,
              onPressed: () {
                //TODO: Handle save
              },
              child: new Text('SAVE')
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Elige fecha'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.add_location),
                  label: const Text('Elige ciudad'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.view_list),
                  label: const Text('Tipo de evento'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),
          Container(
          child: SfCalendar(),
        ),
          ],
        ),
      )
    );
  }
}