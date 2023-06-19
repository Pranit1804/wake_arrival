import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData defaultTheme() => ThemeData(
        primaryColor: AppColor.primaryColor,
        primaryTextTheme: TextTheme(),
      );
}
