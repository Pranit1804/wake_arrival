import 'package:flutter/material.dart';
import 'package:wake_arrival/models/home/home_routes.dart';
import 'package:wake_arrival/models/search/search_routes.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> getAll() => {
        ...HomeRoutes.all(),
        ...SearchRoutes.all(),
      };
}
