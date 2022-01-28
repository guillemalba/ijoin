import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ijoin/model/event.dart';
import 'package:ijoin/screens/filtros.dart';

class SearchPage extends StatefulWidget {
  final dio = Dio();

  @override
  _SearchState createState() => _SearchState();

}

class _SearchState extends State<SearchPage>{
  late ScrollController _controller;
  List _events = [];
  final _formKey = GlobalKey<FormState>();
  var event;
  var location;
  var locationId;
  List type = [];
  List typeId = [];

  void searchEvent(var name, var location, List type) async {
    var textType = null;
    if (type.isNotEmpty) {
      textType = type[0].toString();
      for (int i = 1; i < type.length; i++) {
        textType = textType.toString() + ',' + type[i].toString();
      }
    }

    final response = await widget.dio.get(
      'https://app.ticketmaster.eu/mfxapi/v2/events?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t', queryParameters: {
      //'https://app.ticketmaster.com/discovery/v2/events.json?apikey=Vf8wRn8KjvXH5Tss6EW41x1MXfQfxbGP', queryParameters: {
      'event_name': name,
      'country_ids': location,
      'category_ids': textType
    });

    setState(() {
      if (response.data['pagination']['total'] == 0) {
        _events.clear();
      } else {
        _events = response.data['events'];
      }
    });
  }

  void searchCountry() async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.eu/mfxapi/v2/countries?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t');

    setState(() {
      for (int i = 0; i < response.data['countries'].length; i++) {
        if (response.data['countries'][i]['name'].toString().toLowerCase() == location) {
          locationId = response.data['countries'][i]['id'];
        }
      }
    });
  }

  void searchCategory() async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.eu/mfxapi/v2/categories?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t');

    setState(() {
      typeId.clear();
      for (int i = 0; i < type.length; i++) {
        for (int j = 0; j < response.data['categories'].length; j++) {
          if (response.data['categories'][j]['name'] == type[i]) {
            typeId.add(response.data['categories'][j]['id']);
          }
        }
      }
    });
  }

  Future _openAddEntryDialog() async {
    EventFilter? save = await Navigator.of(context).push(MaterialPageRoute<EventFilter>(
        builder: (BuildContext context) {
          return FiltrosScreen();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
      location = save.getLocation();
      type = save.getCategoria();
      searchCountry();
      searchCategory();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);//the listener for up and down.
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: const Text("Search"),
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Write an event...',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    onChanged: (value) {
                      event = value;
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please write an event to search';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20.0, bottom: 10, left: 20, right: 20),
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
                          _openAddEntryDialog();
                        },
                        child: Text('Filters')
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text((() {
                            if(location != null) {
                              return location + ' - ';
                            }
                            return '';
                          })()),
                          Expanded(child:
                            Text((() {
                              if(type.isNotEmpty) {
                                var typeText = type[0];
                                for (int i = 1; i < type.length; i++) {
                                  typeText = typeText + ', ' + type[i];
                                }
                                return typeText;
                              }
                              return '';
                            })()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                child: SizedBox(
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        final isValid = _formKey.currentState?.validate();
                        if (isValid!) {
                          searchEvent(event, locationId, typeId);
                          //widget.onSearch(event, location);
                        }
                      },
                      child: Text('Search')
                  ),
                ),
              ),
            ],
          ),
        ),
          _events.isEmpty ? Text('No results to display')
          : Expanded(
            child: ListView.builder(
              controller: _controller,//new line
              itemCount: _events.length,
              shrinkWrap: true ,
              itemBuilder: (context, index) => ListTile(
                  contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                title: Text(_events[index]['name']),
                subtitle: Text(_events[index]['venue']['location']['address']['city'] + '\n' + _events[index]['event_date']['value'])
              )
            ),
          ),
        ],
      ),
    ),
  );
}