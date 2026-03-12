import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'customText.dart';
import 'custom_colors.dart';

class AppTheme{
  static const String _fontFamily = 'Manrope';

  /// Text Theme
  static TextTheme _textTheme(Color color, Color hint) => TextTheme(
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: -0.41,
      color: color,
    ),
    bodyMedium: CustomTextStyle.textStyleManrope,
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: hint,
    ),
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: color,
    ),
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      letterSpacing: 1,
      color: color,
    ),
    displayMedium: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: 1,
      color: color,
    ),
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: -0.24,
      color: color,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: -0.24,
      color:CustomColors.backgroundColor,
    ),
  );

  /// ThemeData - Light
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: CustomColors.backgroundColor,
    primaryColor: CustomColors.primaryColor,
    splashColor: Colors.transparent,
    dividerColor: CustomColors.lightGrey,
    cardColor: CustomColors.redDangerColor,
    hintColor: CustomColors.hintColor,
    unselectedWidgetColor: CustomColors.primaryColor,
    disabledColor: Colors.transparent,
    highlightColor: Colors.transparent,
    secondaryHeaderColor: Colors.black,
    textTheme: _textTheme(CustomColors.primaryColor, CustomColors.hintColor),

    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: CustomColors.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    checkboxTheme: _checkboxTheme(CustomColors.primaryColor),
    radioTheme: _radioTheme(CustomColors.primaryColor),
    switchTheme: _switchTheme(CustomColors.primaryColor),
  );

  /// ThemeData - Dark
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: CustomColors.darkBackground,
    primaryColor: CustomColors.darkPrimary,
    splashColor: Colors.transparent,
    dividerColor: CustomColors.darkLightGrey,
    cardColor: CustomColors.redDangerColor,
    hintColor: CustomColors.darkHint,
    unselectedWidgetColor: CustomColors.darkPrimary,
    disabledColor: CustomColors.darkPrimary,
    highlightColor: Colors.transparent,
    textTheme: _textTheme(CustomColors.darkPrimary, CustomColors.darkHint),
    checkboxTheme: _checkboxTheme(CustomColors.darkPrimary),
    radioTheme: _radioTheme(CustomColors.darkPrimary),
    switchTheme: _switchTheme(CustomColors.darkPrimary),
  );

  /// Themed widget styles
  static CheckboxThemeData _checkboxTheme(Color color) =>
      CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected) ? color : null),
      );

  static RadioThemeData _radioTheme(Color color) => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) =>
    states.contains(MaterialState.selected) ? color : null),
  );

  static SwitchThemeData _switchTheme(Color color) => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) =>
    states.contains(MaterialState.selected) ? color : null),
    trackColor: MaterialStateProperty.resolveWith((states) =>
    states.contains(MaterialState.selected) ? color.withOpacity(0.5) : null),
  );


}