import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pogoda/getters/get_stations_list.dart';
import 'package:pogoda/models/station_list_model.dart';
import 'package:pogoda/screens/main_screen.dart';
import 'package:pogoda/screens/searching_by_city.dart';

class PickStation extends StatefulWidget {
  double? lat;
  double?lng;
  String? cityName;
  PickStation({this.lat, this.lng, this.cityName});

  @override
  _PickStationState createState() => _PickStationState();
}

class _PickStationState extends State<PickStation> {
  bool loading = false;
  int _distance = 10;
  int _number = 5;

  String? selected;
  bool allowSaving = false;
  Future<StationList>? stations;
  @override
  void initState() {
    _getPickedStation();
    super.initState();
  }

  List<String>? coordinates;
  _getPickedStation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList('station');
    coordinates = prefs.getStringList('coordinates');

    setState(() {
      selected = result == null ? '' : result[0];
    });
  }

  _savePickedCoordinates(double lat, double lng, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _removePickedStation();
    await prefs
        .setStringList('coordinates', [lat.toString(), lng.toString(), name]);
  }

  _removePickedCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('coordinates');
  }

  _savePickedStation(
      {required String stationId, required String city}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _removePickedCoordinates();
    await prefs.setStringList('station', [stationId, city]);
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      allowSaving = true;
    });
  }

  _removePickedStation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('station');
    await Future.delayed(Duration(milliseconds: 200));
  }

  bool extreme = false;

  @override
  Widget build(BuildContext context) {
    bool isCitySelected =
        widget.cityName != null && widget.lat != null && widget.lng != null;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        actions: [
          allowSaving
              ? IconButton(
                  icon: Icon(Icons.done),
                  color: Theme.of(context).textTheme.headline5!.color,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainScreen()),
                    );
                  },
                )
              : SizedBox(),
        ],
        title: Text(
          "Zmień stację pomiarową",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      body: FutureBuilder(
        future: stations,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.stations.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    height: 60.0,
                    child: RaisedButton(
                      disabledColor: Theme.of(context).accentColor,
                      disabledTextColor: Colors.black,
                      textColor: Theme.of(context).textTheme.headline5!.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(5.0),
                      onPressed: () async {
                        await _removePickedStation();

                        await Future.delayed(Duration(milliseconds: 200));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainScreen()),
                        );
                      },
                      child: Center(
                        child: Text("Przywróć domyślne"),
                      ),
                    ),
                  );
                } else {
                  int i = index - 1;
                  String distance = snapshot.data.stations[i].howFar ?? '';

                  String stationId =
                      snapshot.data.stations[i].stationId.toString();

                  String city = snapshot.data.stations[i].address1 ?? '';
                  String street = snapshot.data.stations[i].address2 ?? '';
                  String address;
                  if (city != '' && street != '') {
                    address = '$city, $street';
                  } else if (city == '') {
                    address = street;
                  } else {
                    address = city;
                  }
                  return Container(
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    height: 60.0,
                    child: RaisedButton(
                      disabledColor: Theme.of(context).accentColor,
                      disabledTextColor: Colors.black,
                      textColor: Theme.of(context).textTheme.headline5!.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(5.0),
                      onPressed: selected != stationId
                          ? () async {
                              await _savePickedStation(
                                  stationId: stationId, city: city);
                              setState(() {
                                selected = stationId;
                              });
                            }
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("$address"),
                          SizedBox(height: 5.0),
                          Text("$distance od Ciebie"),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Container(
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 60.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          extreme = !extreme;
                          _distance = 10;
                          _number = 5;
                        });
                      },
                      child: Text(
                        isCitySelected
                            ? "Filtruj wyniki dla: \n${widget.cityName}"
                            : "Filtruj wyniki",
                        style: TextStyle(
                          fontSize: isCitySelected ? 25.0 : 30.0,
                        ),
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      min: 1.0,
                      max: extreme ? 2010.0 : 50.0,
                      divisions: 49,
                      value: _distance * 1.0,
                      label: '$_distance km od Ciebie',
                      onChanged: (newValue) {
                        setState(() {
                          _distance = newValue.round();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      min: 1.0,
                      max: extreme ? 2450.0 : 50.0,
                      divisions: 49,
                      value: _number * 1.0,
                      label: _number == 1
                          ? '$_number wynik'
                          : _number == 2 || _number == 3 || _number == 4
                              ? '$_number wyniki'
                              : '$_number wyników',
                      onChanged: (newValue) {
                        setState(() {
                          _number = newValue.round();
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 20.0),
                    height: 50.0,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          try {
                            stations = isCitySelected
                                ? getStationsList(
                                    distance: _distance,
                                    number: _number,
                                    lat: widget.lat,
                                    lng: widget.lng,
                                  )
                                : getStationsList(
                                    distance: _distance,
                                    number: _number,
                                  );
                          } catch (e) {
                            throw Exception(e);
                          }
                        });
                      },
                      color: Color.fromRGBO(0, 191, 166, 1),
                      child: !loading
                          ? Text(
                              "Szukaj",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              height: 30.0,
                              width: 30.0,
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                  isCitySelected
                      ? FlatButton(
                          onPressed: () {
                            _savePickedCoordinates(
                                widget.lat!, widget.lng!, widget.cityName!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => MainScreen()),
                            );
                          },
                          child: Text(
                            'Użyj najbliższej instalacji',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline5!.color,
                            ),
                          ),
                        )
                      : selected != '' || coordinates != null
                          ? Container(
                              margin:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              height: 60.0,
                              child: RaisedButton(
                                disabledColor: Theme.of(context).accentColor,
                                disabledTextColor: Colors.black,
                                textColor:
                                    Theme.of(context).textTheme.headline5!.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(5.0),
                                onPressed: () async {
                                  await _removePickedStation();
                                  await _removePickedCoordinates();
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MainScreen()),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    selected != ''
                                        ? "Usuń wybraną stację"
                                        : "Usuń wybraną lokację",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                  isCitySelected
                      ? SizedBox()
                      : FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SearchByCity()),
                            );
                          },
                          child: Text(
                            'Wyszukaj po Twoim adresie',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline5!.color,
                            ),
                          ),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
