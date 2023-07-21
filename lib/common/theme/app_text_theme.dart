import 'package:flutter/material.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextStyle headline1 = TextStyle(
    fontSize: LayoutConstants.dimen_96,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );
  static const TextStyle headline2 = TextStyle(
    fontSize: LayoutConstants.dimen_60,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  static const TextStyle headline3 = TextStyle(
    fontSize: LayoutConstants.dimen_48,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );
  static const TextStyle headline4 = TextStyle(
    fontSize: LayoutConstants.dimen_34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
  );
  static const TextStyle headline5 = TextStyle(
    fontSize: LayoutConstants.dimen_24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headline6 = TextStyle(
    fontSize: LayoutConstants.dimen_20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
  );
  static const TextStyle subtitle1 = TextStyle(
    fontSize: LayoutConstants.dimen_16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  static const TextStyle subtitle2 = TextStyle(
    fontSize: LayoutConstants.dimen_14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const TextStyle bodyText1 = TextStyle(
    fontSize: LayoutConstants.dimen_16,
    letterSpacing: 0.5,
  );
  static const TextStyle bodyText2 = TextStyle(
    fontSize: LayoutConstants.dimen_14,
    letterSpacing: 0.25,
  );
  static const TextStyle button = TextStyle(
    fontSize: LayoutConstants.dimen_14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25,
  );
  static const TextStyle caption = TextStyle(
    fontSize: LayoutConstants.dimen_12,
    letterSpacing: 0.4,
  );
  static const TextStyle overline = TextStyle(
    fontSize: LayoutConstants.dimen_10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}
