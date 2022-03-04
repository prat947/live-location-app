import 'package:flutter/material.dart';

class NayaNaya extends StatefulWidget {
  const NayaNaya({Key? key}) : super(key: key);

  @override
  _NayaNayaState createState() => _NayaNayaState();
}

class _NayaNayaState extends State<NayaNaya> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('details'),
        ),
        body: Text('done'),
      ),
    );
  }
}
