
class ParkingSpace {

  String id;
  int status;
  String last_update;

  ParkingSpace({this.id, this.status, this.last_update});

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'],
      status: json['status'],
      last_update: json['last_update'],
    );
  }


}