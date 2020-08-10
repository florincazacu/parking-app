import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/geofence/geofence_handler.dart';
import 'package:parking_app/requests/parking_slots_request.dart';
import 'package:parking_app/ui/widget/parking_slot_widget.dart';

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
  GeofenceHandler geofenceHandler = GeofenceHandler();

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
    WidgetsFlutterBinding.ensureInitialized();
    NotificationHandler.initNotifications();
    createWidgets();
    Future<List<Widget>>.value(widgets);
    initGeofence();
  }

  Future<void> initGeofence() async {
    if (!mounted) return;
    await geofenceHandler.initialize();
    await geofenceHandler.addLocation("Home", 44.412770, 26.152320, 300.0);
//    geofenceHandler.addLocation("Rosetti Tower", 44.433786, 26.154179, 30000.0);
    await parkingSlotsRequest.fetchStatus().then((parkingLot) {
      if (parkingLot != null && parkingLot.isNotEmpty) {
        geofenceHandler.startListening(parkingLot);
      }
    });
    setState(() {});
  }

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
          geofenceHandler.getCurrentLocation();
        }));
  }
}
