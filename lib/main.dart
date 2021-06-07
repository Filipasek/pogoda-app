import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:pogoda/screens/get_api_key.dart';
import 'package:pogoda/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pogoda/tools/config.dart';
String get bannerAdUnitId {
  /// Always test with test ads
  if (kDebugMode)
    return MobileAds.bannerAdTestUnitId;
  else
    return 'ca-app-pub-9537370157330943/1048173735';
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize(
    bannerAdUnitId: bannerAdUnitId,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pogoda',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          primaryColor: Colors.white,
          accentColor: Color.fromRGBO(255, 182, 185, 1),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.grey),
            headline5: TextStyle(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Comfortaa',
          primaryColor: Color.fromRGBO(40, 44, 55, 1),
          accentColor: Color.fromRGBO(255, 182, 185, 1),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.grey),
            headline5: TextStyle(color: Colors.white),
          ),
        ),
        home: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ConfigData>(context, listen: false).readConfigs();
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return FutureBuilder(
      future: isLogged(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data! as Widget;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<Widget> isLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? result = prefs.getString('apiKey');
  if (result != null && result != '') {
    return MainScreen();
  } else {
    return GetApiKey();
  }
}
