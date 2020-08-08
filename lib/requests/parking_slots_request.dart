import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/model/parking_space.dart';

class ParkingSlotsRequest {

  Future<Map<String, List<ParkingSpace>>> fetchStatus() async {
    Map<String, List<ParkingSpace>> parkingLot = new LinkedHashMap();
    final response = await Dio()
        .get('http://parcare.flashoffices.com/parking-spaces-status');

    if (response.statusCode == 200) {
      Map map = response.data['parking_spaces'] as LinkedHashMap;
      for (String floor in map.keys) {
        List<ParkingSpace> parkingSpaces = [];
        (map[floor] as List).forEach((parkingSpace) {
          String id = parkingSpace["id"];
          int status = parkingSpace["status"];
          String last_update = parkingSpace["last_update"];
          parkingSpaces.add(new ParkingSpace(
              id: id, status: status, last_update: last_update));
        });
        parkingLot.putIfAbsent(floor, () => parkingSpaces);
      }

      return parkingLot;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Map<String, List<ParkingSpace>> getParkingLot() {
    fetchStatus().then((parkingLot) {
      return parkingLot;
    });
  }
}
