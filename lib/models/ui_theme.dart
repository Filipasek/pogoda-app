import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIData extends ChangeNotifier {
  String appTheme = 'system'; // posible: system || light || dark

  changeTheme({@required theme}) async {
    appTheme = theme;
    notifyListeners();
  }

  ThemeData getTheme({required String theme}) {
    if (appTheme != 'system') {
      if (appTheme == 'dark') {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: darkTheme.primaryColor,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
        return darkTheme;
      } else {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: lightTheme.primaryColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        return lightTheme;
      }
    }
    if (theme == 'dark') {
      changeUi(Brightness.light, darkTheme.primaryColor);

      return darkTheme;
    } else {
      changeUi(Brightness.dark, lightTheme.primaryColor);
      return lightTheme;
    }
  }

  void changeUi(Brightness brightness, Color color) {}

  ThemeData lightTheme = ThemeData(
    fontFamily: 'Comfortaa',
    primaryColor: Colors.white,
    accentColor: Color.fromRGBO(255, 182, 185, 1),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.grey),
      headline5: TextStyle(color: Colors.black),
    ),
    brightness: Brightness.light,
  );

  ThemeData darkTheme = ThemeData(
    fontFamily: 'Comfortaa',
    primaryColor: Color.fromRGBO(40, 44, 55, 1),
    accentColor: Color.fromRGBO(255, 182, 185, 1),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.grey),
      headline5: TextStyle(color: Colors.white),
    ),
    brightness: Brightness.light,
  );
}
