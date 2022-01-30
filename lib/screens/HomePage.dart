import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijoin/screens/EventsDetail.dart';
import 'package:intl/intl.dart';

/*
Página principal
*/
class HomePage extends StatefulWidget {
  final dio = new Dio();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>{
  List _events = [];
  var _country;
  var _countryId;
  User? user = FirebaseAuth.instance.currentUser;

  /*
  Para guardar todos los eventos de tu país
  */
  Future searchEvent() async {
    final response = await widget.dio.get(
      'https://app.ticketmaster.eu/mfxapi/v2/events?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t&rows=50', queryParameters: {
      'country_ids': _countryId,
    });

    setState(() {
      if (response.data['pagination']['total'] == 0) {
        _events.clear();
      } else {
        _events = response.data['events'];
      }
    });
  }

  /*
  Para saber el país del usuario
  */
  Future readUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(user!.uid.toString());
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      _country = snapshot.get('country');
    }
    searchCountry();
  }

  /*
  Para guardar el id del país
  */
  Future searchCountry() async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.eu/mfxapi/v2/countries?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t');

    setState(() {
      for (int i = 0; i < response.data['countries'].length; i++) {
        if (response.data['countries'][i]['name'].toString() == _country) {
          _countryId = response.data['countries'][i]['id'];
        }
      }
      searchEvent();
    });
  }

  @override
  void initState() {
    readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Events"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height:15),

            //mostrar el listado de eventos
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                shrinkWrap: true ,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(_events[index]['name'],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(_events[index]['venue']['location']['address']['city'] + '\n' + DateFormat('yyyy-MM-dd').format(DateTime.parse(_events[index]['event_date']['value']))),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventsDetail(text: 'Event: ' + _events[index]['name'] + '\n\n' + 'Location: ' + _events[index]['venue']['name'] + ', ' + _events[index]['venue']['location']['address']['city'] + '\n\n' + 'Date: ' + DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(_events[index]['event_date']['value'])) + '\n\n' + 'Category: ' + _events[index]['categories'][0]['name'], image: _events[index]['images']['large']['url'])),
                    //(event: event)),
                    );
                  },
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
