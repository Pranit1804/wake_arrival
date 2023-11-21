import 'package:flutter/material.dart';

abstract class HomeRoutes {
  static Map<String, WidgetBuilder> all() => {};

  static Map<String, WidgetBuilder> getRoutesWithSettings(
    RouteSettings settings,
  ) =>
      {};
}
