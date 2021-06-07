import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pogoda/screens/get_api_key.dart';
import 'package:pogoda/screens/select_custom_station.dart';
import 'package:pogoda/tools/config.dart';

class SettingsScreen extends StatefulWidget {
  final String? requestsLeft;
  final String? totalRequests;
  final bool? isNotWorking;

  SettingsScreen({this.requestsLeft, this.totalRequests, this.isNotWorking});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = false;
  bool showAlternativeColorsOnChart = false;
  double height = 0.0;
  @override
  Widget build(BuildContext context) {
    height = Provider.of<ConfigData>(context).showChart ? 50.0 : 0.0;
    showAlternativeColorsOnChart = Provider.of<ConfigData>(context).showChart;
    String requests = widget.requestsLeft!;
    String total = widget.totalRequests!;
    bool isNotWorking = widget.isNotWorking ?? false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: requests != null && total != null
            ? Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Pozostałe zapytania: $requests/$total",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                ),
              )
            : Text("Ustawienia"),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(50.0),
                child: Image.asset('assets/credentials/airly.png'),
              ),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor:
                      Theme.of(context).textTheme.headline5!.color,
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).accentColor,
                    checkColor: Colors.white,
                    title: Text(
                      'Kolorowy wskaźnik jakości powietrza',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline5!.color,
                      ),
                    ),
                    value: Provider.of<ConfigData>(context, listen: false).weatherLight,
                    onChanged: (newValue) {
                      Provider.of<ConfigData>(context, listen: false)
                          .changeWeatherLightBoolean(newValue);
                    },
                  ),
                ),
              ),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor:
                      Theme.of(context).textTheme.headline5!.color,
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).accentColor,
                    checkColor: Colors.white,
                    title: Text(
                      'Włącz wspieranie twórcy reklamami',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline5!.color,
                      ),
                    ),
                    value: Provider.of<ConfigData>(context, listen: false).enableAds,
                    onChanged: (newValue) {
                      Provider.of<ConfigData>(context, listen: false)
                          .changeEnableAdsBoolean(newValue);
                    },
                  ),
                ),
              ),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor:
                      Theme.of(context).textTheme.headline5!.color,
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: CheckboxListTile(
                    activeColor: Theme.of(context).accentColor,
                    checkColor: Colors.white,
                    title: Text(
                      'Pokaż wykres temperatury z ostatnich 24 godzin',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline5!.color,
                      ),
                    ),
                    value: Provider.of<ConfigData>(context).showChart,
                    onChanged: (newValue) {
                      Provider.of<ConfigData>(context, listen: false)
                          .changeShowChartBoolean(newValue);
                      setState(() {
                        height = newValue! ? 50.0 : 0.0;
                        showAlternativeColorsOnChart = newValue;
                      });
                    },
                  ),
                ),
              ),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor:
                      Theme.of(context).textTheme.headline5!.color,
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 150),
                  height: height,
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: showAlternativeColorsOnChart
                      ? CheckboxListTile(
                          activeColor: Theme.of(context).accentColor,
                          checkColor: Colors.white,
                          title: Text(
                            'Alternatywne kolory na wykresie',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline5!.color,
                            ),
                          ),
                          value: Provider.of<ConfigData>(context)
                              .showAlternativeColorsOnChart,
                          onChanged: (newValue) {
                            Provider.of<ConfigData>(context, listen: false)
                                .changeShowAlternativeColorsOnChartBoolean(
                                    newValue);
                          },
                        )
                      : SizedBox(),
                ),
              ),
              isNotWorking
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                      height: 50.0,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PickStation()),
                          );
                        },
                        color: Color.fromRGBO(0, 191, 166, 1),
                        child: Text(
                          "Zmień stację",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GetApiKey()),
                    );
                  },
                  color: Color.fromRGBO(0, 191, 166, 1),
                  child: Text(
                    "Zmień klucz API",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
