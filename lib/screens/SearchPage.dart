import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ijoin/screens/filtros.dart';

class SearchPage extends StatefulWidget {
  final dio = Dio();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage>{
  final _formKey = GlobalKey<FormState>();

  var event;
  List _events = [];

  void searchEvent(String query) async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=Vf8wRn8KjvXH5Tss6EW41x1MXfQfxbGP&keyword=NickyJam');

/*      , queryParameters: {
      'q': query
    },
    );*/

    setState(() {
      _events = response.data['_embedded']['events'];
    });
  }

  void _openAddEntryDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new FiltrosScreen();
        },
        fullscreenDialog: true
    ));
  }

  /*Future _openFiltroEntryDialog() async {
    WeightSave save = await Navigator.of(context).push(new MaterialPageRoute<WeightSave>(
        builder: (BuildContext context) {
          return new FiltrosScreen();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
      _addWeightSave(save);
    }
  }*/

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(),
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
              children: [
            Container(
            margin: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextFormField(
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
                ),
            ),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                            primary: Colors.white,
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            _openAddEntryDialog();
                          },
                          child: Text('Filtros')
                      ),
                    )
                ),
                Container(
                margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
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
                )
                ),
                _events.isNotEmpty
                    ? Text("hola")
                    : Container()
                  /*? Expanded(
                    child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(_events[index]["name"]),
                          title: Text(_events[index]["type"]),
                          subtitle: Text(_events[index]["url"])
                        ),
                      );
                    },
                  ),
                )
              : Container()*/
              ],
            ),
          )
        ],
      ),
    ),
  );
}