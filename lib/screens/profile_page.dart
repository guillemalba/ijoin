//Página del Profile
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/screens/edit_profile_page.dart';

import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() =>_ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  bool showPassword = false;
  //FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePic;
  String? _country;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    readUser();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body:ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height:24),
          imageProfile(),
          const SizedBox(height:30),

          // Full name card
          cardTitleView('Full name'),
          cardBodyView('$_firstName $_lastName'),

          const SizedBox(height:15),

          // email card
          cardTitleView('Email'),
          cardBodyView(_email!),

          const SizedBox(height:15),

          // Country card
          cardTitleView('Country'),
          cardBodyView(_country!),

          const SizedBox(height:40),

          // Edit Profile button
          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 0, left: 20, right: 20),
            child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  primary: Colors.redAccent,
                  backgroundColor: Colors.transparent,
                  fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
                  side: BorderSide(
                    width: 2.0,
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> EditProfilePage()),
                  );
                },
                child: const Text('Edit Profile')
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 10, left: 20, right: 20),
            child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  primary: Colors.white,
                  backgroundColor: Colors.redAccent,
                  fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
                ),
                onPressed: () {
                  logout(context);
                },
                child: const Text('Logout')
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget cardTitleView(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
      padding: const EdgeInsets.only(top: 1, bottom: 1, left: 20, right: 20),
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.redAccent,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 1.0)
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget cardBodyView(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, bottom: 10, left: 20, right: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3.0,
        ),
        shape: BoxShape.rectangle,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 1.0)
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack( children: <Widget>[
        _profilePic == null
            ? const CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 70,
        )
            : Container(
          child: CircleAvatar(
            radius: 70.0,
            child: ClipOval(
              child: Image.file(
                File(_profilePic!),
                fit: BoxFit.cover,
                width: 140.0,
                height: 140.0,
              ),
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  offset: Offset(3.0, 3.0),
                  spreadRadius: 3.0)
            ],
          ),
        ),
      ])
    );

  }

  void readUser() async {

    final docUser = FirebaseFirestore.instance.collection('users').doc(user!.uid.toString());
    final snapshot = await docUser.get();
    if (snapshot.exists) {

      _firstName = snapshot.get('firstName');
      _lastName = snapshot.get('lastName');
      _email = snapshot.get('email');
      _profilePic = snapshot.get('profilePic');
      _country = snapshot.get('country');
    }
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}