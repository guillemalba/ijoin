//Página del Edit Profile
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ijoin/model/user.dart';
import 'package:ijoin/widget/button_widget.dart';
import 'package:ijoin/widget/profile_widget.dart';
import 'package:ijoin/widget/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() =>_EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  Widget build(BuildContext context) => Scaffold (
    appBar: AppBar(
      leading: BackButton(),
      elevation: 0,
      title: const Text("I Join"),
      centerTitle: true,
    ),
    body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      physics: BouncingScrollPhysics(),
      children: [
        ProfileWidget(
          imagePath: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.cutypaste.com%2Fentretencion%2F25-modelos-que-se-convirtieron-en-actrices%2F&psig=AOvVaw0eXZ4h4Q28Yf_nmND5Tv19&ust=1642672691199000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKjJ0eXGvfUCFQAAAAAdAAAAABAD',
          isEdit: true,
          onClicked: () async {},
        ),
        const SizedBox(height:24),
        TextFieldWidget(
          label: 'Full name',
          text: 'Maria', //user.firstName & user.secondName
          onChanged: (name){},
        ),
        const SizedBox(height:24),
        TextFieldWidget(
          label: 'Email',
          text: 'maria@gmail.com', //user.email
          onChanged: (email){},
        ),
        const SizedBox(height:24),
        Center(child:buildSaveButton()),
      ],
    ),
  );


  Widget buildSaveButton() => ButtonWidget(
    text: 'Save',
    onClicked: () {
      //guardar datos
    },
  );
}