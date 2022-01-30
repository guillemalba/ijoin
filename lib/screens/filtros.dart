import 'package:flutter/material.dart';
import 'package:ijoin/model/event.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'notifier.dart';

/*
Página de los filtros de búsqueda
*/
class FiltrosScreen extends StatefulWidget {
  final dio = Dio();

  @override
  _FiltrosState createState() => new _FiltrosState();
}

class _FiltrosState extends State<FiltrosScreen> {
  var _currentSelectedDate;
  var _currentCountry;
  List _currentEvent = [];
  List _categories = [];


  /*
  Para guardar todas las categorías
  */
  void searchCategories() async {
    final response = await widget.dio.get(
        'https://app.ticketmaster.eu/mfxapi/v2/categories?apikey=BgunvccCEQmfSA1pZ5a27XrLOGrZgE0t');

    setState(() {
      for (int i = 0; i < response.data['categories'].length; i++) {
        _categories.add(response.data['categories'][i]['name']);
      }
      _showMultiChoiceDialog(context);
    });
  }

  /*
  Para seleccionar las categorías a partir de un dialog de multiselección
  */
  _showMultiChoiceDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      final _multipleNotifier = Provider.of<MultipleNotifier>(context);
      return AlertDialog(
        title: Text("Select one or many categories"),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _categories
                  .map((e) => CheckboxListTile(
                title: Text(e),
                onChanged: (value) {
                  value!
                      ? _multipleNotifier.addItem(e)
                      : _multipleNotifier.removeItem(e);
                },
                value: _multipleNotifier.isHaveItem(e),
              ))
                  .toList(),
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              _currentEvent = _multipleNotifier.getItems();
            },
          ),
        ],
      );
    },
  );


  /*
  Para escribir el país a partir de un dialog
  */
  _showAddCityDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Enter a country"),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Write here',
                  ),
                  onChanged: (value) {
                    _currentCountry = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  /*
  Para seleccionar el día
  */
  void callDatePicker() async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
  }

  Future<DateTime?> getDatePickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.redAccent, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.redAccent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add filters'),
        actions: [
          FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator
                  .of(context)
                  .pop(EventFilter(
                  _currentCountry,
                  _currentSelectedDate,
                  _currentEvent
                  )
                );
              },
              child: Text('SAVE')
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            //Botón para seleccionar el día
            Container(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Choose the date'),
                  onPressed: () {
                    callDatePicker();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),

            //Botón para seleccionar el país
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.add_location),
                  label: const Text('Choose a country'),
                  onPressed: () {
                    _showAddCityDialog(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),

            //Botón para seleccionar las categorías
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.view_list),
                  label: const Text('Choose the event category'),
                  onPressed: () {
                    searchCategories();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}