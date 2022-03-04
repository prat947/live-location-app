import 'package:chaljavmropls/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  String _email = "TEST", _password = "TEST";
  String _name = "";
  String _age = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<String> arr = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup!'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter Email : '),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'EMPTY!';
                }
              },
              onSaved: (input) {
                _email = input!;
              },
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter Password!';
                } else if (input.length < 6) {
                  return 'Less than 6 characters!';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _password = input!;
              },
              decoration: InputDecoration(labelText: 'Enter Password : '),
              obscureText: false,
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter NAME!';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _name = input!;
              },
              decoration: InputDecoration(labelText: 'NAME : '),
              // obscureText: false,
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter AGE';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _age = input!;
              },
              decoration: InputDecoration(labelText: 'AGE : '),
              // obscureText: false,
            ),
            ElevatedButton(
              onPressed: () {
                signup(context);
              },
              child: Text('Sign up '),
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
  //users variable me collection stored hai.

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String email, String pass, User CurrUser,
      [String name = "Not Entered", String age = "-1"]) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(CurrUser.uid)
        .set({
          'e-mail': email,
          'password': pass,
          'name': name,
          'age': age,
          'trigram': arr,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> signup(BuildContext context) async {
    var formState = _formkey.currentState;
    // print('$_email');
    if (formState!.validate()) {
      formState.save();
      try {
        final User? currentUser = (await auth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        trigramcreater(_name);
        addUser(_email, _password, currentUser!, _name, _age);

        // firestore.collection('users').doc(currentUser!.uid).set({"uid": currentUser.uid});

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gethis()),
        );
      } catch (e) {
        print(e);
      }
    }
  }
}
