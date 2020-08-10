import 'package:flutter_geofence/geofence.dart';
import 'package:parking_app/model/parking_space.dart';
import 'package:parking_app/notifications/notification_handler.dart';
import 'package:parking_app/requests/parking_slots_request.dart';

class GeofenceHandler {

  static NotificationHandler notificationHandler = NotificationHandler();

  static ParkingSlotsRequest parkingSlotsRequest = new ParkingSlotsRequest();

//  static void initialize() {
//    Geofence.initialize();
//    Geofence.requestPermissions();
//    Geofence.startListening(GeolocationEvent.entry, (entry) {
//      notificationHandler.scheduleNotification(
//          "Enter a georegion", "Welcome to: ${entry.id}");
//    });
//
//    Geofence.startListening(GeolocationEvent.exit, (entry) {
//      notificationHandler.scheduleNotification(
//          "Exit of a georegion", "Byebye to: ${entry.id}");
//    });
//  }

  Future<void> initialize() async {
    Geofence.initialize();
    Geofence.requestPermissions();
//    Map<String, List<ParkingSpace>> parkingLot = parkingSlotsRequest.getParkingLot();
//    Geofence.startListening(GeolocationEvent.entry, (entry) {
//      parkingSlotsRequest.fetchStatus().then((parkingLot) {
//        int freeSlots = 0;
//        parkingLot.forEach((floor, parkingSpaces) {
//          parkingSpaces.forEach((element) {
//            if (element.status == 1) {
//              freeSlots++;
//            }
//          });
//        });
//        notificationHandler.scheduleNotification("Parking App",
//            "Welcome to ${entry.id}, free parking spaces: $freeSlots");
//      });
//    }

//      Future<Coordinate> coordinates = Geofence.getCurrentLocation();
//
//      coordinates.then((coordinate) {
//        if (coordinate != null) {
//          print("Current location: latitude ${coordinate.latitude} and longitude ${coordinate.longitude}");
//          notificationHandler.scheduleNotification("Current location", "latitude: ${coordinate.latitude} and longitude: ${coordinate.longitude}");
//        }
//      });
//      notificationHandler.scheduleNotification(
//          "Enter a georegion", "Welcome to: ${entry.id}");
//        );

//    Geofence.startListening(GeolocationEvent.exit, (entry) {
//      int freeSlots = 0;
//      parkingLot.forEach((floor, parkingSpaces) {
//        parkingSpaces.forEach((element) {
//          if (element.status == 1) {
//            freeSlots++;
//            notificationHandler.scheduleNotification(
//                "Parking App", "free slots $freeSlots");
//          }
//        });
//      });
//
//      notificationHandler.scheduleNotification(
//          "Exit of a georegion", "Byebye to: ${entry.id}");
//    });

//    Geofence.startListening(GeolocationEvent.entry, (entry) {
//      print("GeolocationEvent.entry");
//      notificationHandler.scheduleNotification("Entry of a georegion", "Welcome to: ${entry.id}");
//    });
//
//    Geofence.startListening(GeolocationEvent.exit, (entry) {
//      print("GeolocationEvent.exit");
//      notificationHandler.scheduleNotification("Exit of a georegion", "Byebye to: ${entry.id}");
//    });
  }

  void getCurrentLocation() {
    print("getCurrentLocation()");
    Future<Coordinate> coordinates = Geofence.getCurrentLocation();

    coordinates.then((coordinate) {
      if (coordinate != null) {
        print(
            "Current location: latitude ${coordinate.latitude} and longitude ${coordinate.longitude}");
        notificationHandler.scheduleNotification("Current location",
            "latitude: ${coordinate.latitude} and longitude: ${coordinate.longitude}");
      }
    });
  }

  Future<void> addLocation(
      String id, double latitude, double longitude, double radius) {
    Geolocation location = Geolocation(
        latitude: latitude, longitude: longitude, radius: radius, id: id);
    Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
      print("geolocation added");
    }).catchError((onError) {
      print("failed to add geolocation, error: $onError");
    });
  }

  Future<void> startListening(Map<String, List<ParkingSpace>> parkingLot) {
    int freeSlots = 0;

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      print("listen to GeolocationEvent.entry: ${entry.id}");
      if (parkingLot != null) {
        parkingLot.forEach((floor, parkingSpaces) {
          parkingSpaces.forEach((element) {
            if (element.status == 1) {
              freeSlots++;
            }
          });
        });
        notificationHandler.scheduleNotification("Parking App",
            "Welcome to ${entry.id}, free parking spaces: $freeSlots");
      }
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      print("listen to GeolocationEvent.exit: ${entry.id}");
      if (parkingLot != null) {
        Future.value(parkingLot).then((parkingLot) {
          if (parkingLot != null) {
            parkingLot.forEach((floor, parkingSpaces) {
              parkingSpaces.forEach((element) {
                if (element.status == 1) {
                  freeSlots++;
                }
              });
            });
          }
        });
        notificationHandler.scheduleNotification("Parking App",
            "Leaving ${entry.id}, free parking spaces: $freeSlots");
      }
    });
  }
}
