import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ijoin/model/event.dart';

class SearchScreen extends StatefulWidget {
  final dio = Dio();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen>{
  final _formKey = GlobalKey<FormState>();

  var event;
  var numEvents;
  List _events = [];

  void searchEvent(String query) async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=Vf8wRn8KjvXH5Tss6EW41x1MXfQfxbGP&keyword=NickyJam');
/*      , queryParameters: {
      'q': query
    },
    );*/
    _events = response.data['_embedded']['events'];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Search")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Escribe un evento...',
                border: OutlineInputBorder(),
                filled: true,
                ),
                onChanged: (value) {
                  event = value;
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Porfavor escribe un evento a buscar';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    primary: Colors.white,
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    final isValid = _formKey.currentState?.validate();
                    if (isValid!) {
                      searchEvent(event);
                    }
                  },
                  child: Text('Buscar')
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ),
  );
}