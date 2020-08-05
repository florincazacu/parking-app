import 'package:flutter/material.dart';
import 'package:parking_app/model/parking_space.dart';

class ParkingSlotWidget {

  Text floor(String floor) {
    return Text("Floor: " + floor, textAlign: TextAlign.center);
  }

  List<Widget> parkingSpaces(List<ParkingSpace> parkingSpaces) {
    List<Widget> spaces = [];
    parkingSpaces.forEach((parkingSpace) {
      spaces.add(SizedBox(width: 8.0));
      spaces.add(FlatButton(
        onPressed: () {},
        color: parkingSpace.status == 0 ? Colors.red : Colors.green,
        child: Text(parkingSpace.id),
      ));
    });
    return spaces;
  }
}
