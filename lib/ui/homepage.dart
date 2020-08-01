import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:parking_app/model/parkingSpace.dart';
import 'package:parking_app/widget/parkingSlotWidget.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => new HomePageState();

  DateTime d =
      DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').parse("2020-07-30T19:10:51");
}

class HomePageState extends State<Home> {
  ParkingSlotWidget parkingSlotWidget = new ParkingSlotWidget();
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parking App"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        )));
  }

  @override
  initState() {
    super.initState();
    createWidgets();
    Future<List<Widget>>.value(widgets);
  }

  void createWidgets() {
    fetchStatus().then((parkingLot) {
      setState(() {
        if (parkingLot != null) {
          parkingLot.forEach((floor, parkingSpaces) {
            widgets.add(parkingSlotWidget.floor(floor));
            widgets.add(
              Wrap(
                alignment: WrapAlignment.center,
                children: parkingSlotWidget.parkingSpaces(parkingSpaces),
              ),
            );
          });
        }
      });
    });
  }

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
}
