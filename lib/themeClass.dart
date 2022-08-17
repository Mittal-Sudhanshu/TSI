import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme:
          ColorScheme.light(primary: Colors.blue, secondary: Colors.blue),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme:
        ColorScheme.dark(secondary: Colors.blue, primary: Colors.blueAccent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    primaryColorDark: Colors.black,
  );
}
