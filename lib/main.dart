

import 'package:flutter/material.dart';
import 'package:parking_app/ui/homepage.dart';

void main() {
  runApp(new ParkingApp());
}

class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Home(title: "Parking App"),
    );
  }
}
