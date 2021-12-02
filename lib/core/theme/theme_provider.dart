import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enum.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({required this.prefs}) {
    final _themeString = prefs.getString('themeOption') ?? 'system';

    currentTheme = enumFromString(_themeString, ThemeMode.values);
  }

//SharedPreferences instance
  final SharedPreferences prefs;

  //Current Theme Default system
  ThemeMode currentTheme = ThemeMode.system;

  Future<void> useDarkTheme() async {
    const _option = ThemeMode.dark;

    //Store locally
    await prefs.setString(
      'themeOption',
      enumToString(_option),
    );

    //Notify Listners
    currentTheme = _option;
    notifyListeners();
  }

  Future<void> useLightTheme() async {
    const _option = ThemeMode.light;

    //Store locally
    await prefs.setString(
      'themeOption',
      enumToString(_option),
    );

    //Notify Listners
    currentTheme = _option;
    notifyListeners();
  }

  Future<void> useSystemTheme() async {
    const _option = ThemeMode.system;

    //Store locally
    await prefs.setString(
      'themeOption',
      enumToString(_option),
    );

    //Notify Listners
    currentTheme = _option;
    notifyListeners();
  }
}
