import 'package:geodesy/geodesy.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:pogoda/models/station_list_model.dart';

Future<StationList> getStationsList(
    {distance, int? number, double? lat, double? lng}) async {
  String _lat;
  String _lng;
  LatLng _currentLocation;
  if (lat != null && lng != null) {
    _lat = lat.toString();
    _lng = lng.toString();
    _currentLocation = LatLng(lat, lng);
  } else {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception("We're fucked");
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception("We're fucked upopp");
      }
    }
    _locationData = await location.getLocation();
    _lat = _locationData.latitude.toString();
    _lng = _locationData.longitude.toString();
    _currentLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _result = prefs.getString('apiKey');

  final String _apikey =
      _result!.trim().replaceAll(new RegExp('[^\u0001-\u007F]'), '');

  final String urlReq =
      'https://airapi.airly.eu/v2/installations/nearest?lat=$_lat&lng=$_lng&maxDistanceKM=$distance&maxResults=$number';
  
  final response = await http.get(Uri.parse(urlReq), headers: {
    'Accept': 'application/json',
    'apikey': _apikey,
    'Accept-Language': 'pl',
  });
  if (response.statusCode == 200) {
    // WeatherData weatherData = new WeatherData.fromJson(
    //     json.decode(response.body), response.headers, response.statusCode);
    StationList stationList =
        new StationList.fromJson(json.decode(response.body), _currentLocation);
    return stationList;
  } else {
    // ErrorData errorData = new ErrorData.fromJson(json.decode(response.body), response.statusCode);
    // return errorData;
    throw Exception("fuck");
  }
}
