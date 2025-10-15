import 'package:flutter/material.dart';
import 'package:wake_arrival/models/home/home_routes.dart';
import 'package:wake_arrival/models/routes/routes_constant.dart';
import 'package:wake_arrival/models/search/search_routes.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> getAll() => {
        ...HomeRoutes.all(),
        ...SearchRoutes.all(),
      };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    WidgetBuilder? builder;

    if (settings.name != null) {
      switch (settings.name) {
        case RouteConstant.searchLandingPage:
          builder = SearchRoutes.getRoutesWithSettings(settings)[settings.name];
          break;
        case RouteConstant.fullMapPage:
          builder = HomeRoutes.getRoutesWithSettings(settings)[settings.name];
          break;
      }
      if (builder != null) {
        return MaterialPageRoute(builder: builder, settings: settings);
      }
    }
    return null;
  }
}
