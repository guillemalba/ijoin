//Página del Edit Profile

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/screens/home.dart';
import 'package:ijoin/screens/profile_page.dart';
import 'package:ijoin/widget/button_widget.dart';
import 'package:ijoin/widget/profile_widget.dart';
import 'package:ijoin/widget/textfield_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'HomePage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() =>_EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;

  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePic;
  String? _country;

  File? image;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to pick image $e.");
    }

  }

  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    readUser();

    return Scaffold (
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    imageProfile(),
                  ],
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "First Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Last Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Last Name",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 35,
              ),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Country",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Country",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 75,
              ),

              TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    primary: Colors.white,
                    backgroundColor: Colors.redAccent,
                    fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
                  ),
                  onPressed: () {
                    saveToFirebase();
                  },
                  child: Text('Save')
              ),
            ],
          ),
        ),
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
        _imageFile == null
            ? const CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 80,
        )
            : CircleAvatar(
          radius: 80.0,
          child: ClipOval(
            child: Image.file(
              File(_imageFile!.path),
              fit: BoxFit.fill,
              width: 160.0,
              height: 160.0,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon (
              Icons.camera_alt,
              color: Colors.teal,
              size: 28,
            ),
          ),
        ),
      ])
    );

  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ]),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;

    });
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

  Widget buildSaveButton() => ButtonWidget(
    text: 'Save',
    onClicked: () {
      saveToFirebase();
    },
  );

  saveToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid.toString())
        .set({
            'email': user.email,
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'profilePic': _imageFile!.path,
            'uid': user.uid.toString(),
            'country': countryController.text,
        });
    Fluttertoast.showToast(msg: "Information updated successful");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

}