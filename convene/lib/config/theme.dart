import 'package:convene/config/palette.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData buildTheme() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonColor: Palette.darkerGrey,
      canvasColor: Palette.lightGrey,
      accentColor: Palette.lightBlue,
      primaryColor: Palette.darkerGrey,
      buttonTheme: const ButtonThemeData(
        buttonColor: Palette.darkerGrey,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.black, //flat button text color
      ),
    );
  }
}
