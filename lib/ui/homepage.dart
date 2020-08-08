import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:parking_app/geofence/geofencing_handler.dart';
import 'package:parking_app/model/parking_space.dart';
import 'package:parking_app/requests/parking_slots_request.dart';
import 'package:parking_app/ui/widget/parking_slot_widget.dart';

//import 'package:flutter_geofence/geofence.dart';
import 'package:parking_app/notifications/notification_handler.dart';

ParkingSlotsRequest parkingSlotsRequest = new ParkingSlotsRequest();

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
//  GeofenceHandler geofenceHandler = GeofenceHandler();
  GeofencingHandler geofencingHandler = GeofencingHandler();

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
    NotificationHandler.initNotification();
    createWidgets();
    Future<List<Widget>>.value(widgets);
//    initGeofence();
    geofencingHandler.initPlatformState();
    setState(() {});
  }

//  initGeofence() async {
//    GeofenceHandler.initialize();
//    geofenceHandler.addLocation("Rosetti Tower", 44.413038, 26.152583, 30.0);
//    parkingSlotsRequest.fetchStatus().then((parkingLot) {
//      geofenceHandler.startListening(parkingLot);
//    });
//  }

  void createWidgets() {
    parkingSlotsRequest.fetchStatus().then((parkingLot) {
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
    widgets.add(RaisedButton(
        child: Text("Get current location"),
        onPressed: () {
//          geofenceHandler.getCurrentLocation();
          geofencingHandler.getCurrentLocation();
        }));
  }
}
