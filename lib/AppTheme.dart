import 'package:flutter/material.dart';

class AppTheme{

  static final lightTheme = _getTheme();
  static get normalBlue => const Color(0xff1d2b43);
  static get darkerBlue => const Color(0xff161d2b);
  static get lightBlue => const Color(0xff4f6d9c);




  static ThemeData _getTheme(){
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      //primaryColor: _darkBlue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,

      buttonTheme: ButtonThemeData(
        buttonColor: normalBlue,
        textTheme: ButtonTextTheme.accent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
           primary: lightBlue,
        )
      )
    );
  }
}