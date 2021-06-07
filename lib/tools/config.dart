import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates easily accesible configuration data for things like app theme.
class ConfigData extends ChangeNotifier {
  /// Tells if the light indicating quality of the weather by color should be shown.
  late bool weatherLight;
  late bool showChart;
  late bool showAlternativeColorsOnChart;
  late bool enableAds;
  late SharedPreferences prefs;
  List<String> templateConfig = ['true', '0', 'true', 'false', 'true'];

  /// 0 is white theme, 1 is dark theme
  late int themeColor;

  void changeWeatherLightBoolean(newValue) {
    saveConfig(id: 0, newValue: newValue);
    notifyListeners();
    readConfigs();
  }
  void changeEnableAdsBoolean(newValue) {
    saveConfig(id: 4, newValue: newValue);
    notifyListeners();
    readConfigs();
  }
  void changeShowChartBoolean(newValue) {
    saveConfig(id: 2, newValue: newValue);
    notifyListeners();
    readConfigs();
  }
  void changeShowAlternativeColorsOnChartBoolean(newValue) {
    saveConfig(id: 3, newValue: newValue);
    notifyListeners();
    readConfigs();
  }

  void saveConfig({@required id, @required newValue}) {
    List<String> oldValue = prefs.getStringList('configData') ?? templateConfig;
    oldValue[id] = newValue.toString();
    prefs.setStringList('configData', oldValue);
  }

  void readConfigs() async {
    prefs = await SharedPreferences.getInstance();
    List<String> notPresent() {
      prefs.setStringList('configData', templateConfig);
      return templateConfig;
    }

    List<String> configData = prefs.getStringList('configData') ?? notPresent();
    if (configData.length < templateConfig.length) {
      List<String> newArray = templateConfig;

      for (var i = 0; i <= configData.length - 1; i++) {
        newArray[i] = configData[i];
      }
      prefs.setStringList('configData', newArray);
      configData = newArray;
    }
    weatherLight = configData[0] == 'false' ? false : true;
    showChart = configData[2] == 'false' ? false : true;
    showAlternativeColorsOnChart = configData [3] == 'false' ? false : true;
    enableAds = configData[4] == 'false' ? false : true;
    themeColor = int.parse(configData[1]);
    notifyListeners();
  }
}
