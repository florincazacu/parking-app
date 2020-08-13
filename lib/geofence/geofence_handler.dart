import 'package:flutter_geofence/geofence.dart';
import 'package:parking_app/model/parking_space.dart';
import 'package:parking_app/notifications/notification_handler.dart';
import 'package:parking_app/requests/parking_slots_request.dart';

class GeofenceHandler {
  static NotificationHandler notificationHandler = NotificationHandler();

  static ParkingSlotsRequest parkingSlotsRequest = new ParkingSlotsRequest();

  Future<void> initialize() async {
    Geofence.initialize();
    Geofence.requestPermissions();
    Map<String, List<ParkingSpace>> parkingLot =
    parkingSlotsRequest.getParkingLot();
    Geofence.startListening(GeolocationEvent.entry, (entry) {
      parkingSlotsRequest.fetchStatus().then((parkingLot) {
        int freeSlots = 0;
        parkingLot.forEach((floor, parkingSpaces) {
          parkingSpaces.forEach((element) {
            if (element.status == 1) {
              freeSlots++;
            }
          });
        });
        notificationHandler.scheduleNotification("Tellence Parking",
            "Welcome to ${entry.id}, free parking spaces: $freeSlots");
      });
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      int freeSlots = 0;
      parkingLot.forEach((floor, parkingSpaces) {
        parkingSpaces.forEach((element) {
          if (element.status == 1) {
            freeSlots++;
          }
        });
      });
      notificationHandler.scheduleNotification("Tellence Parking",
          "Goodbye ${entry.id}, free parking spaces: $freeSlots");
    });
  }

  Future<void> _addListeners() async {
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
}
