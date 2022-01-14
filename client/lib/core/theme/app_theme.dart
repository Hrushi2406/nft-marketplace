// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:nfts/core/utils/utils.dart';

class AppTheme {
  ///LIGHT MODE
  ///
  static const Color _scaffoldColor = Color(0xfff9f9f9);
  static const Color _surfaceColor = Color(0xffF0F0F0);

  static const Color _primaryColor = Color(0xff000000);
  static const Color _secondaryColorLight = Color(0xff000000);

  static const Color _errorColorLight = Color(0xffb00020);

  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: _primaryColor,
      primaryColorDark: _primaryColor,
      primaryColorLight: _primaryColor,
      errorColor: _errorColorLight,
      scaffoldBackgroundColor: _scaffoldColor,
      brightness: Brightness.light,
      disabledColor: Colors.grey.withOpacity(0.50),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.black,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xffDEDADA),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: _primaryColor,
        primaryVariant: _primaryColor,
        secondary: _secondaryColorLight,
        secondaryVariant: _scaffoldColor,
        error: _errorColorLight,
        surface: _surfaceColor,
        background: _scaffoldColor,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(14),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: Colors.black,
        ),
        headline2: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(14),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: Colors.black,
        ),
        headline3: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        headline4: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        headline6: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        bodyText1: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(10),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(10),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(10),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
        caption: TextStyle(
          fontSize: rf(12),
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0.6,
          color: Colors.black,
        ),
        button: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(12),
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        overline: TextStyle(
          fontFamily: 'Outfit',
          fontSize: rf(8),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.96,
          color: Colors.black,
        ),
      ),
    );
  }
}
