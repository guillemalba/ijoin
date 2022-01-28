//Página del Profile
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/screens/edit_profile_page.dart';
import 'package:ijoin/widget/button_widget.dart';
import 'package:ijoin/widget/profile_widget.dart';

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
          const SizedBox(height:40),

          const Text(
            'First Name\n',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Text(
            '${userModel.firstName}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          //buildName(userModel),
          const SizedBox(height:20),

          const Text(
            'Second Name\n',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Text(
            '${userModel.lastName}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height:20),

          const Text(
            'Email\n',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Text(
            '${_email}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
          ),

          //buildEmail(user),
          const SizedBox(height:70),
          Center(child:buildEditButton()),
          const SizedBox(height: 15),
          ActionChip(
              label: const Text("Logout"),
              onPressed: () {
                logout(context);
              }),
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

  Widget imageProfile() {
    return Center(
      child: Stack( children: <Widget>[
        _profilePic == null
            ? const CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 80,
        )
            : CircleAvatar(
          radius: 80.0,
          child: ClipOval(
            child: Image.file(
              File(_profilePic!),
              fit: BoxFit.fill,
              width: 160.0,
              height: 160.0,
            ),
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
    }
  }

  Widget buildEditButton() => ButtonWidget(
    text: 'Edit Profile',
    onClicked: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> EditProfilePage()),
      );
    },
  );

  /*Widget buildName(User user) => Column(
    children: [
      Text("${userModel.firstName} ${userModel.secondName}",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500,
          ),
       ),
      const SizedBox(height: 4),
        Text("${userModel.email}",
            style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,),
        ),
    ],
  );*/

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}