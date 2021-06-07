import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pogoda/getters/weather_data.dart';
import 'package:pogoda/parts/chart.dart';
import 'package:pogoda/screens/settings_screen.dart';
import 'package:pogoda/tools/config.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  String get bannerAdUnitId {
    if (kDebugMode)
      return MobileAds.bannerAdTestUnitId;
    else
      return 'ca-app-pub-9537370157330943/9292429604';
  }

  late Future weatherData;
  bool toDelete = false;
  deleteCustomStation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('coordinates');
    await prefs.remove('station');
  }

  @override
  void initState() {
    setState(() {
      weatherData = getWeatherData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode == 200) {
            DateTime localTime = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(snapshot.data!.time, true)
                .toLocal();

            String min = localTime.minute.toString();
            String minute = min.length == 1 ? '0' + min : min;
            String hour = localTime.hour.toString();
            String time = '$hour:$minute';
            String city = snapshot.data!.city;

            int temp = snapshot.data!.temperature;
            String temptext = temp.toString() + "°"; // temperature
            Color hexToColor(String code) {
              return new Color(
                  int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
            }

            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            requestsLeft: snapshot.data!.requestsLeft,
                            totalRequests: snapshot.data!.requestsPerDay,
                            isNotWorking: false,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                centerTitle: true,
                elevation: 0,
                leading: Provider.of<ConfigData>(context).weatherLight
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hexToColor(snapshot.data.color),
                          ),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      )
                    : SizedBox(
                        width: 0.0,
                        height: 0.0,
                      ),
                title: Text(
                  'Dane z $time',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).accentColor,
                  onRefresh: () async {
                    setState(() {
                      weatherData = getWeatherData();
                    });
                    return weatherData;
                  },
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: constraints.maxHeight,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              city != null && city.length > 2
                                  ? Center(
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 150),
                                        margin: EdgeInsets.fromLTRB(
                                            25.0, 0.0, 25.0, 0.0),
                                        // padding: EdgeInsets.fromLTRB(
                                        //     12.0, 5.0, 12.0, 3.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            color: toDelete
                                                ? Color.fromRGBO(244, 36, 72, 1)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .color as Color,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: ButtonTheme(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minWidth: 0,
                                          height: 0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            child: FlatButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                if (toDelete) {
                                                  await deleteCustomStation();
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            MainScreen()),
                                                  );
                                                } else {
                                                  setState(() {
                                                    toDelete = true;
                                                  });
                                                }
                                                Future.delayed(
                                                    Duration(seconds: 3), () {
                                                  setState(() {
                                                    toDelete = false;
                                                  });
                                                });
                                              },
                                              child: AnimatedSize(
                                                vsync: this,
                                                duration:
                                                    Duration(milliseconds: 150),
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      12.0, 5.0, 12.0, 3.0),
                                                  child: Text(
                                                    toDelete
                                                        ? "Kliknij jeszcze raz aby usunąć"
                                                        : city,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .color,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                padding:
                                    Provider.of<ConfigData>(context).showChart
                                        ? const EdgeInsets.fromLTRB(
                                            20.0, 80.0, 20.0, 20.0)
                                        : const EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        snapshot.data.description,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .color,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: Text(
                                        snapshot.data.advice !=
                                                snapshot.data.description
                                            ? snapshot.data.advice
                                            : '',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      temptext,
                                      style: TextStyle(
                                        fontFamily: 'quicksand',
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .color,
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Provider.of<ConfigData>(context).showChart &&
                                          snapshot.data.history != null &&
                                          snapshot.data.forecast != null
                                      ? WeatherChart(
                                          chartData: snapshot.data.history +
                                              snapshot.data.forecast,
                                          altColors:
                                              Provider.of<ConfigData>(context)
                                                  .showAlternativeColorsOnChart,
                                        )
                                      : SizedBox(),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 50.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, i) {
                                        String text = "";
                                        switch (i) {
                                          case 0:
                                            String btext = snapshot
                                                .data.pressure
                                                .toString();
                                            text = btext != null
                                                ? "Ciśnienie: $btext\hPa"
                                                : '';
                                            break;
                                          case 1:
                                            String btext = snapshot
                                                .data.humidity
                                                .toString();
                                            text = btext != null
                                                ? "Wilgotność: $btext\%"
                                                : '';
                                            break;
                                          case 2:
                                            String btext =
                                                snapshot.data.pm25.toString();
                                            text = btext != null
                                                ? "PM25: $btext\µg/m³"
                                                : '';
                                            break;
                                          case 3:
                                            String btext =
                                                snapshot.data.pm10.toString();
                                            text = btext != null
                                                ? "PM10: $btext\µg/m³"
                                                : '';
                                            break;
                                          case 4:
                                            String btext =
                                                snapshot.data.pm1.toString();
                                            text = btext != null
                                                ? "PM1: $btext\µg/m³"
                                                : '';
                                            break;
                                        }
                                        return text != null
                                            ? Container(
                                                height: 50.0,
                                                padding: EdgeInsets.only(
                                                    right: 10.0, left: 10.0),
                                                child: Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(width: 0.0);
                                      },
                                    ),
                                  ),
                                  Provider.of<ConfigData>(context,
                                              listen: false)
                                          .enableAds
                                      ? BannerAd(
                                          unitId: bannerAdUnitId,
                                          size: BannerSize.ADAPTIVE,
                                          loading: Center(
                                              child: Text('Ładowanie reklamy')),
                                          error: Center(
                                              child: Text(
                                                  'Nie udało się załadować reklamy')),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            int code = snapshot.data.statusCode;
            String message = snapshot.data!.errorMessage;
            return Scaffold(
              appBar: AppBar(
                leading: SizedBox(
                  width: 0.0,
                  height: 0.0,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Theme.of(context).textTheme.headline5!.color,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            isNotWorking: code == 404 ? false : true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                centerTitle: true,
                elevation: 0,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              body: LayoutBuilder(
                builder: (context, constraints) => RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).accentColor,
                  onRefresh: () async {
                    setState(() {
                      weatherData = getWeatherData();
                    });
                    return weatherData;
                  },
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: constraints.maxHeight,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Wystąpił błąd!\n",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .color,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Kod błędu: $code\n"),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Błąd: $message\n"),
                            ),
                            code == 401
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Nieprawidłowy klucz API. Wejdź w ustawienia, aby zmienić na prawidłowy."),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              leading: SizedBox(
                width: 0.0,
                height: 0.0,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          isNotWorking: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: SizedBox(
                width: 80.0,
                height: 80.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(0, 191, 166, 1),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
