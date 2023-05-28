import 'package:flutter/material.dart';

import 'color_schemes.g.dart';
import 'custom_color.g.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  extensions: [lightCustomColors],
);

final dartTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  extensions: [darkCustomColors],
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.background,
      iconSize: 30),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xFF1c1929),
    indicatorColor:
        darkColorScheme.primary, //navBar_Bacground = 60% of color #473f66
    labelTextStyle:
        MaterialStatePropertyAll(TextStyle(color: darkColorScheme.primary)),
    iconTheme: MaterialStatePropertyAll(IconThemeData(color: darkColorScheme.background)),
    

  ),
);
