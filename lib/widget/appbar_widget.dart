import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context){

  return AppBar(

    leading: BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,

    title: const Text("I Join"),
    centerTitle: true,
  );
}