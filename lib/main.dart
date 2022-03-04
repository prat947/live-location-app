// ignore_for_file: unused_import

import 'package:chaljavmropls/details.dart';
import 'package:chaljavmropls/page.dart';
import 'package:chaljavmropls/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: FutureBuilder(
        future: _fbapp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error!${snapshot.error.toString()}');
            return Text('WRONG');
          } else if (snapshot.hasData) {
            return MaterialApp(
              home: Home(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
  ));
}

class Home extends StatelessWidget {
  String _email = "", _password = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('apptest'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter Email'),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Still EMPTY!';
                }
              },
              onSaved: (input) {
                _email = input!;
              },
            ),
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter Password';
                } else if (input.length < 6) {
                  return 'Less than 6 characters!';
                } else {
                  _formkey.currentState!.save();
                }
              },
              onSaved: (input) {
                _password = input!;
              },
              decoration: InputDecoration(labelText: 'Enter Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                signin(context);
              },
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => signup()));
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signin(BuildContext context) async {
    var formState = _formkey.currentState;
    // print('$_email');
    if (formState!.validate()) {
      // print('$_email');
      formState.save();
      print('$_email');
      try {
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
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
