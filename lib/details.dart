// ignore_for_file: unused_import, camel_case_types, unused_field

import 'package:chaljavmropls/group.dart';
import 'package:chaljavmropls/main.dart';
import 'package:chaljavmropls/mapdis.dart';
import 'package:chaljavmropls/Signup.dart';
import 'package:chaljavmropls/update.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

FirebaseAuth auth1 = FirebaseAuth.instance;
FirebaseFirestore firestore1 = FirebaseFirestore.instance;
// LocationPermission per df  0mission = await Geolocator.checkPermission();

class gethis extends StatefulWidget {
  const gethis({Key? key}) : super(key: key);

  @override
  _gethisState createState() => _gethisState();
}

class _gethisState extends State<gethis> {
  final _email = auth1.currentUser!.email;
  final _uid = auth1.currentUser!.uid;
  Map<String, dynamic>? data1 = {'name': 'bruh'};
  var position;
  var locmsg = "";
  var locmsg1 = "";
  double lat = 0;
  double longi = 0;
  Future<void> getloc() async {
    // LocationPermission permission = await Geolocator.checkPermission();

    //waits for the user to give permission.

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position posi = position;
    // posi.latitude;
    // print('$');

    setState(() {
      lat = posi.latitude;
      longi = posi.longitude;
      print('$locmsg');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore1
        .collection('users')
        .doc((auth1.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        data1 = value.data();
        print(auth1.currentUser!.uid);
        print('$value.data() $data1');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your info'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              // Text('                                                 '),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => upd()));
                },
                child: Text('Update/change details.'),
              ),
              ElevatedButton(
                onPressed: signout,
                child: Text('Sign out'),
              ),
              ElevatedButton(
                onPressed: () {
                  getloc();
                  print(position);
                  updateposi();
                },
                child: Text('Update Location.'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ggroups()));
                  },
                  child: Text('Groups section.')),
            ],
          ),
        ));
  }

  Future<void> signout() async {
    auth1.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> updateposi1(User CurrUser) async {
    // Call the user's CollectionReference to add a new user
    firestore1
        .collection("users")
        .doc(CurrUser.uid)
        .set({'Latitude': lat, 'Longitude': longi}, SetOptions(merge: true));
  }

  Future<void> updateposi() async {
    User? user = auth2.currentUser;
    String? _email = user!.email;
    updateposi1(user);
  }
}
