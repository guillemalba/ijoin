import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ijoin/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'MyEventsPage.dart';
import 'profile_page.dart';
import 'SearchPage.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  int _paginaActual = 0;

  List <Widget> _paginas = [
    HomePage(),
    MyEventsPage(),
    SearchPage(),
    ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30, color: Colors.white, semanticLabel: "Home"),
      const Icon(Icons.task, size: 30, color: Colors.white, semanticLabel: "My Events"),
      const Icon(Icons.search, size: 30, color: Colors.white, semanticLabel: "Search"),
      const Icon(Icons.supervised_user_circle, size: 30, color: Colors.white, semanticLabel: "Profile"),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.red,
      body: _paginas[_paginaActual],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.red,
        height: 60,
        index: _paginaActual,
        items: items,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration (milliseconds: 250),
        onTap: (index){
          setState(() {
            _paginaActual = index;
          });
        },
      ),
    );
  }
  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}