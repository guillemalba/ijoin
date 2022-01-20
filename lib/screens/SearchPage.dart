//Página del Searcher
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("I Join"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset("assets/iJoinLogo.png", fit: BoxFit.contain),
              ),
              Text(
                "Welcome to the Search screen",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}