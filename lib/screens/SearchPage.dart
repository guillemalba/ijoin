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

  void searchEvent(String query) async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=Vf8wRn8KjvXH5Tss6EW41x1MXfQfxbGP&keyword=Barcelona');

/*      , queryParameters: {
      'q': query
    },
    );*/

    setState(() {
      _events = response.data['_embedded']['events'];
    });
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
      leading: BackButton(),
      elevation: 0,
      title: const Text("Search"),
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SearchForm(onSearch: searchEvent),
          _events.isEmpty ? Text('No results to display')
          : Expanded(
            child: ListView.builder(
              controller: _controller,//new line
              itemCount: _events.length,
              shrinkWrap: true ,
              itemBuilder: (context, index) => ListTile(
                title: Text(_events[index]['name']),
                subtitle: Text(_events[index]["type"])

              )
            ),
          ),
        ],
      ),
    ),
  );
}

class SearchForm extends StatefulWidget {
  SearchForm({required this.onSearch});

  final void Function(String search) onSearch;

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  var event;

  Future _openAddEntryDialog() async {
    EventFilter? save = await Navigator.of(context).push(MaterialPageRoute<EventFilter>(
        builder: (BuildContext context) {
          return FiltrosScreen();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
    }
  }

  @override
  Widget build(context) {
    return Form(
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
            width: double.infinity,
            height: 50,
              margin: const EdgeInsets.all(20),
              child: SizedBox(
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
              ),
          ),
          Container(
            width: double.infinity,
            height: 50,
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
                        widget.onSearch(event);
                      }
                    },
                    child: Text('Buscar')
                ),
              ),
          ),
/*                  ? Expanded(
                    child: ListView.separated(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 400,
                        width: double.infinity,
                        child: Center(
                          child: Text(_events[index]["name"])
*//*                          title: Text(_events[index]["type"]),
                          subtitle: Text(_events[index]["url"])*//*
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                )
              : Container()*/
        ],
      ),
    );
  }
}