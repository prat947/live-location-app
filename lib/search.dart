// ignore_for_file: unused_import, duplicate_import, non_constant_identifier_names

import 'dart:io';
import 'package:chaljavmropls/details.dart';
import 'package:chaljavmropls/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chaljavmropls/details.dart';
import 'package:chaljavmropls/page.dart';
import 'package:chaljavmropls/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth4 = FirebaseAuth.instance;
FirebaseFirestore firestore4 = FirebaseFirestore.instance;

class searchpage extends StatefulWidget {
  const searchpage({Key? key}) : super(key: key);

  @override
  State<searchpage> createState() => _searchpageState();
}

//Display all matching by checking
// if macthing hai , and tapped to select and then change the chip viewer.
//chip viewer me cancel hua to display hona chahiye.

class _searchpageState extends State<searchpage> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Search");
  TextEditingController searchInput = new TextEditingController();
  List<String> matchingusernames = ['No match :('];
  List<String> selectedusernames = ['cool'];

  // List<String> names;
  List<Map<String, dynamic>> fdata = [
    {'yo': 4}
  ];
  bool done = false;
  Future<void> getdata() async {
    var curr =
        await firestore4.collection('users').doc(auth4.currentUser!.uid).get();
    var yoyo = await firestore4.collection('users').get();
    yoyo.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic>? temp;
      temp = document.data() as Map<String, dynamic>;
      fdata.add(temp);
    });
    done = true;
  }

  Widget buildChip(String label, Color color) {
    return Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(label[0].toUpperCase()),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        deleteIcon: Icon(
          Icons.close,
        ),
        onDeleted: () {
          setState(() {
            selectedusernames.remove(label);
          });
        },
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0));
  }

  // selecedusernames = ['cool'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // color: Colors.white,
      // child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      appBar: AppBar(
        title: cusSearchBar,
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  if (cusIcon.icon == Icons.search) {
                    cusIcon = Icon(Icons.cancel);
                    cusSearchBar = TextField(
                        controller: searchInput,
                        onChanged: (text) {
                          // print(text);
                          setState(() {
                            // print(text);
                            if (!done) getdata();
                            // print(fdata);
                            List<String> tmp = ['No match :('];
                            for (Map<String, dynamic> ele in fdata) {
                              if (ele['trigram'] != null) {
                                for (String trigram in ele['trigram']) {
                                  if (text.contains(trigram)) {
                                    if (ele['name'] != null &&
                                        tmp.contains(ele['name']) == false)
                                      tmp.add(ele['name']);
                                  }
                                }
                              }
                            }
                            if (tmp.contains('No match :(') && tmp.length > 1) {
                              tmp.remove('No match :(');
                            }
                            matchingusernames = tmp;
                          });
                        },
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for names',
                            hintStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ));
                  } else {
                    cusIcon = Icon(Icons.search);
                    cusSearchBar = Text('Search');
                  }
                });
              },
              icon: cusIcon),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 25),
          SizedBox(
            height: 70,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: selectedusernames.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index > 0)
                    return buildChip(selectedusernames[index], Colors.orange);
                  else
                    return Text('');
                }),
          ),
          SizedBox(height: 25),
          Text(
            'Matching Users',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: matchingusernames.length,
              itemBuilder: (BuildContext context, int) {
                return Card(
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            if (selectedusernames
                                .contains(matchingusernames[int])) {
                              ;
                            } else {
                              selectedusernames.add(matchingusernames[int]);
                            }
                          });
                        },
                        title: Text(matchingusernames[int])));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 320.0, bottom: 20),
            child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: IconButton(
                  color: Colors.white,
                  highlightColor: Colors.black,
                  onPressed: () {
                    openDialog();
                  },
                  icon: Icon(Icons.done),
                )),
          ),
        ],
      ),
    );
  }

  TextEditingController creategrp = new TextEditingController();

  // CollectionReference groups = firestore4.collection('groups');
  Future<void> addgroup() async {
    // return .then((value) => print('added'));

    // .catchError((error) => print('$error'));
    final String name1 = '${creategrp.text}';
    List<String> final1 = [];
    for (int i = 1; i < selectedusernames.length; i++) {
      final1.add(selectedusernames[i]);
    }
    await firestore4.collection('groups').add({
      'groupname': name1,
      'users': final1,
    });
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Enter Group Name'),
            content: TextField(
              controller: creategrp,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // print('${creategrp.text}');
                    addgroup();
                    Navigator.of(context).pop();
                  },
                  child: Text('Create')),
            ],
          ));
}
