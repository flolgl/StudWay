import 'package:flutter/material.dart';

class AppTheme{

  static final lightTheme = _getTheme();

  static ThemeData _getTheme(){
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: const Color(0xff1d2b43),

      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xff1d2b43),
        textTheme: ButtonTextTheme.accent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
           primary: const Color(0xff4f6d9c),
        )
      )
    );
  }
}