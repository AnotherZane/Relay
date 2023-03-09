import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blueGrey,
    onPrimary: Colors.white,
    // Colors that are not relevant to AppBar in LIGHT mode:
    secondary: Colors.grey,
    onSecondary: Colors.grey,
    background: Colors.grey,
    onBackground: Colors.grey,
    surface: Colors.grey,
    onSurface: Colors.grey,
    error: Colors.grey,
    onError: Colors.grey,
  )
);

final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF313338),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    surface: Color(0xFF2b2d31),
    onSurface: Colors.white,
    // Colors that are not relevant to AppBar in DARK mode:
    primary: Color(0xFF5865F2),
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Color(0xFF82858f),
    background: Color(0xFF313338),
    onBackground: Colors.white,
    error: Color(0xFFED4245),
    onError: Colors.white,
  ),
);
