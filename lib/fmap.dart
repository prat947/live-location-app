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
import 'group.dart' as globals;
// import 'package:geolocator/geolocator.dart';

FirebaseAuth auth5 = FirebaseAuth.instance;
FirebaseFirestore firestore5 = FirebaseFirestore.instance;

class mapshow extends StatefulWidget {
  const mapshow({Key? key}) : super(key: key);

  @override
  State<mapshow> createState() => _mapshowState();
}

class _mapshowState extends State<mapshow> {
  // Object? get selected => null
  // Object? get groups => null
  //
  // List<Marker>

  var _myLocation;

  late GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(27.7137735, 85.315626);

  List<Map<String, dynamic>> data = [
    {'yo': 1}
  ];
  bool done = false;
  List<LatLng> points = [];
  Future<void> loadlocations() async {
    var curr = await firestore5.collection('users').get();
    curr.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> tmp;
      tmp = document.data() as Map<String, dynamic>;
      if (tmp['name'] != null && globals.selected.contains(tmp['name'])) {
        double lat = 0.0;
        double long = 0.0;
        if (tmp['Latitude'] != null) lat = tmp['Latitude'];
        if (tmp['Longitude'] != null) long = tmp['Longitude'];
        // print(lat);
        LatLng use = LatLng(lat, long);
        if (points.contains(use) == false) points.add(use);
      }
    });
    int i = 1;
    for (LatLng tmp in points) {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(i.toString()),
        position: tmp, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker $i First ',
          // snippet: 'My  Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      i++;
    }
    //add more markers here

    done = true;
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      if (!done) loadlocations();
      print('yoy');
      print(points);
      //add more markers here
    });
    print('ayooooo');
    print(markers);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiple Markers in Google Map"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation, //initial position
          zoom: 15.0, //initial zoom level
        ),
        markers: getmarkers(), //markers to show on map
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
  // });
}
// }
