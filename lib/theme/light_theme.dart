import 'package:user/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  // primaryColor: const Color(0xFFff0023),
  primaryColor: const Color(0xFFE51800),
  secondaryHeaderColor: const Color(0xFFF4CE0A),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFE51800))),
  colorScheme: const ColorScheme.light(
          primary: Color(0xFFE51800), secondary: Color(0xFFE51800))
      .copyWith(surface: const Color(0xFFF3F3F3))
      .copyWith(error: const Color(0xFFE84D4F)),
);
