import 'package:flutter/material.dart';
import 'package:wake_arrival/models/home/presentation/home.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';

abstract class HomeRoutes {
  static Map<String, WidgetBuilder> all() => {
        RouteConstant.searchPage: (context) => const Home(),
      };

  static Map<String, WidgetBuilder> getRoutesWithSettings(
    RouteSettings settings,
  ) =>
      {};
}
