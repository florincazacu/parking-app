//import 'dart:isolate';
//import 'dart:ui';
//
//import 'package:geofencing/geofencing.dart';
//import 'package:parking_app/notifications/notification_handler.dart';
//import 'package:parking_app/requests/parking_slots_request.dart';
//
//class GeofencingHandler {
//  static NotificationHandler notificationHandler = NotificationHandler();
//
//  static ParkingSlotsRequest parkingSlotsRequest = new ParkingSlotsRequest();
//
//  //"Rosetti Tower", 44.413038, 26.152583, 30.0
//
//  String geofenceState = 'N/A';
//  double latitude = 44.413038;
//  double longitude = 26.152583;
//  double radius = 30.0;
//  ReceivePort port = ReceivePort();
//
//  final List<GeofenceEvent> triggers = <GeofenceEvent>[
//    GeofenceEvent.enter,
//    GeofenceEvent.dwell,
//    GeofenceEvent.exit
//  ];
//
//  final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
//      initialTrigger: <GeofenceEvent>[
//        GeofenceEvent.enter,
//        GeofenceEvent.exit,
//        GeofenceEvent.dwell
//      ],
//      loiteringDelay: 1000 * 60);
//
//  static void callback(List<String> ids, Location l, GeofenceEvent e) async {
//    print('Fences: $ids Location $l Event: $e');
//    final SendPort send =
//        IsolateNameServer.lookupPortByName('geofencing_send_port');
//    send?.send(e.toString());
//    _onGeofenceEvent(l, e);
//  }
//
//  void registerGeofence() {
//    GeofencingManager.registerGeofence(
//        GeofenceRegion('Rosetti Tower', latitude, longitude, radius, triggers,
//            androidSettings: androidSettings),
//        callback);
//  }
//
//  static _onGeofenceEvent(Location l, GeofenceEvent e) {
//    parkingSlotsRequest.fetchStatus().then((parkingLot) {
//      int freeSlots = 0;
//      parkingLot.forEach((floor, parkingSpaces) {
//        parkingSpaces.forEach((element) {
//          if (element.status == 1) {
//            freeSlots++;
//          }
//        });
//      });
//      notificationHandler.scheduleNotification(
//          "Parking App", "Welcome to $l, free parking spaces: $freeSlots");
//    });
//  }
//
//  void getCurrentLocation() {
//
//  }
//
//  Future<void> initPlatformState() async {
//    print('Initializing...');
//    await GeofencingManager.initialize();
//    print('Initialization done');
//    GeofencingManager.registerGeofence(
//        GeofenceRegion('Rosetti Tower', latitude, longitude, radius, triggers,
//            androidSettings: androidSettings),
//        callback);
//  }
//
//  String numberValidator(String value) {
//    if (value == null) {
//      return null;
//    }
//    final num a = num.tryParse(value);
//    if (a == null) {
//      return '"$value" is not a valid number';
//    }
//    return null;
//  }
//}
