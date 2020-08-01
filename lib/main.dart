import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

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
  List<Widget> buttons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parking App"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
        ));
  }

  @override
  initState() {
    super.initState();
    createButtons();
    Future<List<Widget>>.value(buttons);
  }

  void createButtons() {
    fetchStatus().then((value) {
      setState(() {
        if (value != null) {
          value.forEach((key, value) {
            List<Widget> row = [];
            List<Widget> floor = [];
            floor.add(Text("Floor: " + key,
                textAlign: TextAlign.center));
            buttons.addAll(floor);
            List<Sensor> sensors = value;
            sensors.forEach((sensor) {
              Color c;
              if (sensor.status == 0) {
                c = Colors.red;
              }
              if (sensor.status == 1) {
                c = Colors.green;
              }
              row.add(FlatButton(
                onPressed: () {},
                color: c,
                child: Text(sensor.id),
              ));
            });
            buttons.add(
              Wrap(
                alignment: WrapAlignment.center,
                children: row,
              ),
            );
          });
        }
      });
    });
  }

  Future<Map<String, List<Sensor>>> fetchStatus() async {
    Map<String, List<Sensor>> sensors = new LinkedHashMap();
    final response = await Dio()
        .get('http://parcare.flashoffices.com/parking-spaces-status');

    if (response.statusCode == 200) {
      Map map = response.data['parking_spaces'] as LinkedHashMap;
      for (String key in map.keys) {
        List<Sensor> temp = [];
        List s = map[key] as List;
        s.forEach((element) {
          String id = element["id"];
          int status = element["status"];
          String last_update = element["last_update"];
          Sensor sensor =
              new Sensor(id: id, status: status, last_update: last_update);
          temp.add(sensor);
        });
        sensors.putIfAbsent(key, () => temp);
      }

      return sensors;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}

class Sensor {
  String id;
  int status;
  String last_update;

  Sensor({this.id, this.status, this.last_update});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      status: json['status'],
      last_update: json['last_update'],
    );
  }
}
