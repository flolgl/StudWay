import 'package:flutter/material.dart';

class AppTheme{

  static final lightTheme = _getTheme();
  static get normalBlue => const Color(0xff273a69);
  static get darkerBlue => const Color(0xff1b2a52);
  static get lightBlue => const Color(0xffc5feed);




  static ThemeData _getTheme(){
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: normalBlue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,

      buttonTheme: ButtonThemeData(
        buttonColor: normalBlue,
        textTheme: ButtonTextTheme.accent,
      ),

      colorScheme: ThemeData().colorScheme.copyWith(
        primary: normalBlue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
           primary: lightBlue,
        )
      )
    );
  }
}