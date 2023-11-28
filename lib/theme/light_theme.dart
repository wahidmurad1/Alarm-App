import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // useMaterial3: true,
  colorScheme: ColorScheme.light(
    background: cWhiteColor,
    primary: cTextPrimaryColor,
    secondary: Colors.grey[800]!,
  ),
);
