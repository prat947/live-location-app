// ignore_for_file: unused_import, camel_case_types

// import 'dart:html';
import 'package:chaljavmropls/details.dart';
import 'package:chaljavmropls/page.dart';
import 'package:chaljavmropls/Signup.dart';
import 'package:chaljavmropls/search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'fmap.dart';

FirebaseAuth auth3 = FirebaseAuth.instance;
FirebaseFirestore firestore3 = FirebaseFirestore.instance;
List<String> selected = [];

class ggroups extends StatefulWidget {
  const ggroups({Key? key}) : super(key: key);

  @override
  _ggroupsState createState() => _ggroupsState();
}

class _ggroupsState extends State<ggroups> {
  List<Map<String, dynamic>> finaldata = [
    {'name': 'lmao'}
  ];

  String username = "JJ Olatunji.";

  List<String> groups = [];

  // @override
  // void initstate() {
  //   firestore3
  //       .collection('users')
  //       .doc(auth3.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       username = value.data()!['name'];
  //       print(username);
  //     });
  //   });
  // }

  Future<List<Map<String, dynamic>>> getdata() async {
    var curr =
        await firestore3.collection('users').doc(auth3.currentUser!.uid).get();
    username = curr.data()!['name'];
    var yoyo = await firestore3.collection('groups').get();
    // print(yoyo);
    yoyo.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic>? temp;
      temp = document.data() as Map<String, dynamic>;
      // print(temp);
      finaldata.add(temp);
      for (dynamic ele in temp['users'] ?? []) {
        String nname = (ele ?? null) as String;
        // print(nname);
        if (nname == username) {
          // print(temp['groupname']);
          if (temp['groupname'] != null &&
              groups.contains(temp['groupname']) == false)
            groups.add(temp['groupname']);
        }
      }
      // print(temp);
    });
    return finaldata;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Your Groups'),
              ),
              body: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            onTap: () {
                              String fs = groups[index];

                              for (Map<String, dynamic> ele in finaldata) {
                                if (ele['groupname'] != null) {
                                  if (ele['groupname'] == fs) {
                                    if (ele['users'] != null) {
                                      for (String x in ele['users']) {
                                        selected.add(x);
                                      }
                                    }
                                  }
                                }
                              }

                              // selected = groups[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mapshow()),
                              );
                            },
                            title: Text(groups[index])));
                  }),
              floatingActionButton: FloatingActionButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => searchpage()),
                  )
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
            );
          }
        });
  }
}
