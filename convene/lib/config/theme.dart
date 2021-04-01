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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(ContinuousRectangleBorder(
            side: BorderSide(color: Colors.cyan[900], width: 4),
            borderRadius: BorderRadius.circular(30.0),
          )),
          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 30),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return (states.contains(MaterialState.pressed)) ? Palette.lightGrey : Palette.darkerGrey;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return (states.contains(MaterialState.pressed)) ? Palette.darkerGrey : Palette.lightGrey;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            return const TextStyle(fontSize: 18);
          }),
          padding: MaterialStateProperty.resolveWith<EdgeInsets>((states) {
            return const EdgeInsets.symmetric(horizontal: 30, vertical: 10);
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return (states.contains(MaterialState.pressed)) ? Colors.red : Colors.red;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return (states.contains(MaterialState.pressed)) ? Colors.red : Colors.red;
          }),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.black, //flat button text color
      ),
    );
  }
}
