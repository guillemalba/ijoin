import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ijoin/model/event.dart';
import 'package:ijoin/screens/filtros.dart';
import 'package:intl/intl.dart';
import 'package:ijoin/screens/EventsDetail.dart';

/*
Página de búsqueda
*/
class SearchPage extends StatefulWidget {
  final dio = Dio();

  @override
  _SearchState createState() => _SearchState();

}

class _SearchState extends State<SearchPage>{
  List _events = [];
  final _formKey = GlobalKey<FormState>();
  var event;
  var location;
  var locationId;
  List category = [];
  List categoryId = [];
  var date;

  /*
  Función para buscar el evento en la API. Añade los parámetros de los filtros a la query, para poder acotar la búsqueda.
  */
  void searchEvent() async {
    var nextDay, formattedDate;
    if (date != null) {
      nextDay = date?.add(Duration(days: 1));
      formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date);
      nextDay = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(nextDay);
    }

    var categoryIdConcat = categoryId.join(",");
    final response = await widget.dio.get(
      'https://app.ticketmaster.eu/mfxapi/v2/events?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t', queryParameters: {
      'event_name': event,
      'country_ids': locationId,
      'category_ids': categoryIdConcat,
      'eventdate_from': formattedDate,
      'eventdate_to': nextDay
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
  Función para encontrar el id del país
  */
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

  /*
  Función para encontrar el id de las categorias
  */
  void searchCategory() async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.eu/mfxapi/v2/categories?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t');

    setState(() {
      categoryId.clear();
      for (int i = 0; i < category.length; i++) {
        for (int j = 0; j < response.data['categories'].length; j++) {
          if (response.data['categories'][j]['name'] == category[i]) {
            categoryId.add(response.data['categories'][j]['id']);
          }
        }
      }
    });
  }

  /*
  Función para mostrar la pantalla de los filtros
  */
  Future _openAddEntryDialog() async {
    EventFilter? save = await Navigator.of(context).push(MaterialPageRoute<EventFilter>(
        builder: (BuildContext context) {
          return FiltrosScreen();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
      location = save.getLocation();
      category = save.getCategoria();
      date = save.getDate();
      searchCountry();
      searchCategory();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: const Text("Searcher"),
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
              children: <Widget>[

                //botón añadir filtros
                Container(
                width: double.infinity,
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10, left: 20, right: 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      primary: Colors.redAccent,
                      backgroundColor: Colors.transparent,
                      fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
                      side: const BorderSide(
                        width: 2.0,
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      _openAddEntryDialog();
                    },
                    child: Text('Add filters')
                  ),
                ),

                //mostrar filtros seleccionados
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      if (location != null) ...[
                        Text(location)
                      ],
                      if (date != null) ...[
                        Text(DateFormat('yyyy-MM-dd').format(date))
                      ],
                      if (category.isNotEmpty) ...[
                        Text(category.join(", "))
                      ]
                    ],
                  ),
                ),

                //escribir el nombre del evento a buscar
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.only(left: 20, right:20 ),
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

                //botón buscar
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
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
                            searchEvent();
                            const Text("Results:\n");
                            //widget.onSearch(event, location);
                          }
                        },
                        child: Text('Search')
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Results:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                const SizedBox(height: 10),
              ],
            ),
          ),

          //en el caso de que no haya resultados
          _events.isEmpty ? Text('No results to display')

          //en el caso de que si haya resultados. Mostramos un listado de los eventos
          : Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              shrinkWrap: true ,
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.only(top: 10, bottom: 10,left:20, right:20),
                title: Text(_events[index]['name'],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(_events[index]['venue']['location']['address']['city'] + '\n' + _events[index]['event_date']['value']),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsDetail(text: 'Evento: \n\n' + _events[index]['name'] + '\n\n' + 'Ubicación: \n\n' + _events[index]['venue']['location']['address']['city'] + '\n\n' + 'Fecha: \n\n' + _events[index]['event_date']['value'], image: _events[index]['images']['large']['url'])),
                  //(event: event)),
                  );
                },
              )
            ),
          ),
        ],
      ),
    ),
  );
}