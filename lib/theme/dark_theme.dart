import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    background: cBackgroundColor,
    // primary: Colors.grey[900]!,
    primary: cWhiteColor,
    secondary: cTextSecondaryColor,
  ),
);
