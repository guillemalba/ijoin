import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? country;

  UserModel({this.uid, this.email, this.firstName, this.lastName, this.profilePic, this.country});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profilePic: map['profilePic'],
      country: map['country'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'country': country,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    profilePic: json['profilePic'],
    country: json['country'],
  );
}