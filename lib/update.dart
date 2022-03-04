// ignore_for_file: unused_import

import 'package:chaljavmropls/details.dart';
import 'package:chaljavmropls/page.dart';
import 'package:chaljavmropls/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth2 = FirebaseAuth.instance;
FirebaseFirestore firestore2 = FirebaseFirestore.instance;

class upd extends StatefulWidget {
  const upd({Key? key}) : super(key: key);

  @override
  _updState createState() => _updState();
}

class _updState extends State<upd> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _newpass = "";
  String _newage = "";
  String _newname = "";
  List<String> arr = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Update.'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Enter updated password : '),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please Enter Password : ';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _newpass = input!;
              },
              obscureText: false,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter new name : '),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter name : ';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _newname = input!;
              },
              // obscureText: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter age : '),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter age : ';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _newage = input!;
              },
              // obscureText: true,
            ),
            ElevatedButton(
              onPressed: infoupdate,
              child: Text('Update.'),
            ),
          ],
        ),
      ),
    );
  }

  void trigramcreater(String inp) {
    int ptr1 = 0;
    int ptr2 = 1;
    int ptr3 = 2;
    int i = 0;
    while (ptr3 != inp.length) {
      arr.insert(i, inp[ptr1] + inp[ptr2] + inp[ptr3]);

      i++;
      ptr1++;
      ptr2++;
      ptr3++;
    }

    print(arr);
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String email, String pass, User CurrUser,
      [String name = "Not Entered", String age = "-1"]) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(CurrUser.uid)
        .set({
          'e-mail': email, // John Doe
          'password': pass,
          'name': name,
          'age': age,
          'trigram': arr, // Stokes and Sons
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> infoupdate() async {
    var formState1 = _formkey.currentState;
    // print('$formState1');
    if (formState1!.validate()) {
      User? user = auth2.currentUser;
      String? _email = user!.email;
      user.updatePassword('$_newpass');
      trigramcreater(_newname);
      addUser(_email!, _newpass, user, _newname, _newage);
    }
  }
}
