//import 'dart:async';
//
//import 'package:geolocator/geolocator.dart';
//
//class Locator {
//  var geolocator = Geolocator();
//  var locationOptions =
//      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
//
//  void getPermissions() async {
//    GeolocationStatus geolocationStatus =
//        await geolocator.checkGeolocationPermissionStatus();
//  }
//
//  void getPlacemark() async{
//    List<Placemark> placemark = await geolocator.placemarkFromAddress("Maria Rosetti 6, Bucharest");
//  }
//
//  Future<Position> getPosition() async {
//    Position position = await geolocator.getCurrentPosition(
//        desiredAccuracy: LocationAccuracy.high);
//    return position;
//  }
//
//  StreamSubscription<Position> onLocationChange() {
//    StreamSubscription<Position> positionStream = geolocator
//        .getPositionStream(locationOptions)
//        .listen((Position position) {
//      print(position == null
//          ? 'Unknown'
//          : position.latitude.toString() +
//              ', ' +
//              position.longitude.toString());
//    });
//    return positionStream;
//  }
//}
