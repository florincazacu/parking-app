import 'dart:collection';

import 'package:parking_app/model/parkingSpace.dart';

class ParkingLot {
  Map<String, List<ParkingSpace>> parkingLot = new LinkedHashMap();

  ParkingLot({this.parkingLot});

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      parkingLot: json['parking_spaces'],
    );
  }
}
