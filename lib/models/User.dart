

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? username;
  String? email;
  String? password;
  String? state;
  String? role;

  User({this.username, this.email, this.password, this.state, this.role});

  factory User.fromDocument(DocumentSnapshot snapshot){
    String username = "";
    String email = "";
    String password = "";
    String state = "";
    String role = "";

    try{
      username = snapshot.get("username");
    }catch(e){}

    try{
      email = snapshot.get("email");
    }catch(e){}

    try{
      password = snapshot.get("password");
    }catch(e){}

    try{
      state = snapshot.get("state");
    }catch(e){}

    try{
      role = snapshot.get("role");
    }catch(e){}

    return User(
      email: email,
      role: role,
      password: password,
      state: state,
      username: username
    );
  }

  Map<String, String> toMap() {
    return {
      "email": email ?? "",
      "username": username ?? "",
      "password": password ?? "",
      "state": state ?? "",
      "role": role ?? "",
    };
  }
}