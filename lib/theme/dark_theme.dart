import 'package:user/util/app_constants.dart';
import 'package:flutter/material.dart';

import '../util/colors.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  //primaryColor: const Color(0xFFff0023),
  primaryColor: const Color(0xFFD60000),
  secondaryHeaderColor: const Color(0xFFffda00),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor:  Color(0xff514746),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFE51800))),
  colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE51800), secondary: Color(0xFFE51800))
      .copyWith(surface: const Color(0xFF191A26))
      .copyWith(error: const Color(0xFFdd3135)),
);
