import 'dart:collection';

import 'package:parking_app/model/parking_space.dart';

class ParkingLot {
  Map<String, List<ParkingSpace>> parkingSpaces = new LinkedHashMap();

  ParkingLot({this.parkingSpaces});

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      parkingSpaces: json['parking_spaces'],
    );
  }
}
