//Página del Profile
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/screens/EditProfilePage.dart';
import 'package:ijoin/widget/button_widget.dart';
import 'package:ijoin/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() =>_ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("I Join"),
        centerTitle: true,
      ),
      body:
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.cutypaste.com%2Fentretencion%2F25-modelos-que-se-convirtieron-en-actrices%2F&psig=AOvVaw0eXZ4h4Q28Yf_nmND5Tv19&ust=1642672691199000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKjJ0eXGvfUCFQAAAAAdAAAAABAD',
                onClicked: () async {},
              ),
              const SizedBox(height:24),
              Text("Name",
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
             //buildName(user),
              const SizedBox(height:24),
              Text("Email",
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
              //buildEmail(user),
              const SizedBox(height:24),
              Center(child:buildEditButton()),
            ],
          ),
        );
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
      Text(user.firstName,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500,
          ),
       ),
      const SizedBox(height: 4),
        Text(user.email,
            style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,),
        ),
    ],
  );*/

}