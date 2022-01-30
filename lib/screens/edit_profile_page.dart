import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/screens/home.dart';
import 'package:image_picker/image_picker.dart';

/*
Página para editar el perfil
*/
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
  final countryEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    readUser();

    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          labelText: "First Name",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: '$_firstName',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final lastNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          labelText: "Last Name",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: '$_lastName',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final countryField = TextFormField(
        autofocus: false,
        controller: countryEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Country cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          countryEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.location_on_sharp),
          labelText: "Country",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: '$_country',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Scaffold (
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 10, left: 20, right: 20),
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
              firstNameField,
              const SizedBox(height: 35,),
              lastNameField,
              const SizedBox(height: 35,),
              countryField,
              const SizedBox(height: 75,),

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
                  child: const Text('Save')
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
              fit: BoxFit.cover,
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

  saveToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    if (_imageFile != null) {
      _profilePic = _imageFile!.path;
    }
    if (firstNameEditingController.text.isNotEmpty) {
      _firstName = firstNameEditingController.text;
    }
    if (secondNameEditingController.text.isNotEmpty) {
      _lastName = secondNameEditingController.text;
    }
    if (countryEditingController.text.isNotEmpty) {
      _country = countryEditingController.text;
    }
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid.toString())
        .set({
            'email': user.email,
            'firstName': _firstName,
            'lastName': _lastName,
            'profilePic': _profilePic,
            'uid': user.uid.toString(),
            'country': _country,
        });
    Fluttertoast.showToast(msg: "Information updated successful");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

}