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
            side: const BorderSide(color: Palette.black, width: 2),
            borderRadius: BorderRadius.circular(4),
          )),
          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 30),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Palette.black;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(ContinuousRectangleBorder(
            side: const BorderSide(color: Palette.lightBlue, width: 2),
            borderRadius: BorderRadius.circular(4),
          )),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            return const TextStyle(fontSize: 18);
          }),
          padding: MaterialStateProperty.resolveWith<EdgeInsets>((states) {
            return const EdgeInsets.symmetric(horizontal: 30, vertical: 10);
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Palette.black;
          }),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.black, //flat button text color
      ),
    );
  }
}
