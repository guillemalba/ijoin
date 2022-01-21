import 'package:flutter/material.dart';
import 'package:ijoin/model/event.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'notifier.dart';

class FiltrosScreen extends StatefulWidget {
  final dio = Dio();

  @override
  _FiltrosState createState() => new _FiltrosState();
}

class _FiltrosState extends State<FiltrosScreen> {
  var _currentSelectedDate;
  var _currentCity;
  List<String> _currentEvent = [];
  List<String> _categories = [];

  void callDatePicker() async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
  }

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

  //MULTI
  _showMultiChoiceDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      final _multipleNotifier = Provider.of<MultipleNotifier>(context);
      return AlertDialog(
        title: Text("Select one type or many types"),
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


  //CIUDAD
  _showAddCityDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Enter a city or country"),
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
                    _currentCity = value;
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

  //EVENT
  _showAddEventDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Enter the type event"),
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
                    //_currentEvent = value;
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
              Navigator.of(context).pop(

              );
            },
          ),
        ],
      );
    },
  );

  //DATA
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
                  _currentCity,
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
            Container(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Elige fecha'),
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
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.add_location),
                  label: const Text('Elige ciudad'),
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
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child:
                TextButton.icon(
                  icon: const Icon(Icons.view_list),
                  label: const Text('Tipo de evento'),
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