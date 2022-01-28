//Página del Home
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ijoin/screens/EventsDetail.dart';

class HomePage extends StatefulWidget {
  final dio = Dio();

  @override
  _HomeState createState() => _HomeState();
}

class Event {
  late String name;
  late String location;
  late String date;
}

class _HomeState extends State<HomePage>{
  late ScrollController _controller;
  List _events = [];
  late Event event;

  void searchEvent(var location) async {
    final response = await widget.dio.get(
      'https://app.ticketmaster.eu/mfxapi/v2/events?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t&rows=50', queryParameters: {
      'country_ids': location,
    });

    setState(() {
      if (response.data['pagination']['total'] == 0) {
        _events.clear();
      } else {
        _events = response.data['events'];
      }
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);//// the listener for up and down.
    //searchEvent("Spain");
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {//you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {//you can do anything here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    searchEvent("724");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Events"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height:15),
            Expanded(
              child: ListView.builder(
                controller: _controller,//new line
                itemCount: _events.length,
                shrinkWrap: true ,
                itemBuilder: (context, index) => ListTile(
                   contentPadding: const EdgeInsets.all(15),
                    title: Text(_events[index]['name'],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(_events[index]['venue']['location']['address']['city'] + '\n' + _events[index]['event_date']['value']),

                    onTap: () {

                      event.name = _events[index]['name'];
                      event.location = _events[index]['venue']['location']['address']['city'];
                      event.date = _events[index]['event_date']['value'];

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventsDetail(event: event)),//(text: 'Evento: \n\n' + _events[index]['name'] + '\n\n' + 'Ubicación: \n\n' + _events[index]['venue']['location']['address']['city'] + '\n\n' + 'Fecha: \n\n' + _events[index]['event_date']['value'] )),
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
