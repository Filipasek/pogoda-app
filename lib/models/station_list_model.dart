import 'package:geodesy/geodesy.dart';

// class Address{
//   final String country;
//   final String city;
//   final String street;
//   final String number;
//   final String displayAddress1;
//   final String displayAddress2;

//   Address({
//     this.city,
//     this.country,
//     this.displayAddress1,
//     this.street,
//     this.displayAddress2,
//     this.number,
//   });
// }
class Station {
  final int stationId;
  final String address1;
  final String address2;
  final String
      howFar; // outputs distance between user and a station (example: "16 km")

  Station({
    required this.stationId,
    required this.address1,
    required this.address2,
    required this.howFar,
  });

  factory Station.fromJson(Map<String, dynamic> json, LatLng _currentLocation) {
    Geodesy geodesy = Geodesy();
    LatLng stationLocation =
        LatLng(json['location']['latitude'], json['location']['longitude']);
    num dist = geodesy.distanceBetweenTwoGeoPoints(
        _currentLocation, stationLocation); //in meters
    // String distance = (dist/1000).round().toString();
    String distance = '';
    String unit = "km";
    if (dist < 1000) {
      distance = dist.round().toString();
      unit = "m";
    } else if (dist < 10000) {
      distance = (((dist / 100).round()) / 10).toString();
    } else {
      distance = (dist / 1000).round().toString();
    }
    return Station(
      stationId: json['id'],
      address1: json['address']['displayAddress1'],
      address2: json['address']['displayAddress2'],
      howFar: "$distance$unit",
    );
  }
}

class StationList {
  final List<Station> stations;
  // var lgt;
  StationList({
    required this.stations,
  });

  factory StationList.fromJson(
      List<dynamic> parsedJson, LatLng _currentLocation) {
    List<Station> stations = <Station>[];
    stations =
        parsedJson.map((i) => Station.fromJson(i, _currentLocation)).toList();
    return new StationList(
      stations: stations,
    );
  }
}
