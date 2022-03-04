// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore3 = FirebaseFirestore.instance;

class mapimpl extends StatefulWidget {
  const mapimpl({Key? key}) : super(key: key);

  @override
  _mapimplState createState() => _mapimplState();
}

class _mapimplState extends State<mapimpl> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Firemap()),
    );
  }
}

class Firemap extends StatefulWidget {
  const Firemap({Key? key}) : super(key: key);

  @override
  _FiremapState createState() => _FiremapState();
}

class _FiremapState extends State<Firemap> {
  var value1;
  var value2;
  double lat = 0;
  double long = 0;
  bool done = false;

  var mapController;
  var curloc;
  @override
  void initState() {
    super.initState();
    print('lat= $lat');
    firestore3
        .collection('users')
        .doc((auth.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        lat = value.data()!['Latitude'];
        long = value.data()!['Longitude'];
        print(lat);
        done = true;
        // print(curloc.latitude);
      });
    });
    print(lat);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        done
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 15,
                  // _onMapCreated
                ),
                // onMapCreated: _onMapCreated,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
              )
            : Text('LOADING'),
      ],
    );
  }
}
